from fastapi import APIRouter, Path, Query
from dbs_assignment.config import settings
import psycopg2
router = APIRouter()


def get_1_query(user_id: int):
    try:
        connection = psycopg2.connect(
            host=settings.DATABASE_HOST,
            port=settings.DATABASE_PORT,
            dbname=settings.DATABASE_NAME,
            user=settings.DATABASE_USER,
            password=settings.DATABASE_PASSWORD,
        )

        cursor = connection.cursor()

        cursor.execute("""select p_id, p_title, p_type, p_date at time zone 'UTC' || '+00', row_f
from (
    (select distinct on (p_id) p_id, p_title, 'post' as p_type, p_date,(row_number() over ()) as row_f, (row_number() over ()) * 2 as row_num
    from (
        select distinct on (p_id) p_id, b_id, p_title, b_title, p_date, b_date
        from (
            select b.id as b_id, p.id as p_id, p.title as p_title, b.name as b_title, b.date as b_date, p.creationdate as p_date,
            row_number() over (partition by b.id order by abs(extract(epoch from p.creationdate - b.date))) as rn
            from badges as b
            join users as u on b.userid = u.id
            left join posts as p on u.id = p.owneruserid
            where b.userid = %s
            and p.creationdate < b.date
            ) as inner_query1
        where rn = 1 and p_id is not null
        ) as row_num_p
    )
    union all
    (
    select distinct on (p_id) b_id, b_title, 'badge' as b_type, b_date,(row_number() over ()) as row_f, (row_number() over ()) * 2 + 1 as row_num
    from (
        select distinct on (p_id) p_id, b_id, p_title, b_title, p_date, b_date
        from (
            select b.id as b_id, p.id as p_id, p.title as p_title, b.name as b_title, b.date as b_date, p.creationdate as p_date,
            row_number() over (partition by b.id order by abs(extract(epoch from p.creationdate - b.date))) as rn
            from badges as b
            join users as u on b.userid = u.id
            left join posts as p on u.id = p.owneruserid
            where b.userid = %s
            and p.creationdate < b.date
            ) as inner_query2
        where rn = 1 and p_id is not null
        ) as row_num_b
    )
) as subquery
order by row_num
 """, (user_id, user_id))

        db_version = cursor.fetchall()

        cursor.close()
        connection.close()

        return db_version

    except Exception as e:
        return str(e)


@router.get("/v3/users/{user_id}/badge_history")
async def status(user_id: int = Path(...)):
    users = get_1_query(user_id)

    json_users = []
    for user in users:

        json_user = {
            "id": user[0],
            "title": user[1],
            "type": user[2],
            "created_at": user[3],
            "position": user[4]
        }
        json_users.append(json_user)

    return {'items': json_users}

#2##########################################################################################################################################

def get_2_query(tag: str, count: int):
    try:
        connection = psycopg2.connect(
            host=settings.DATABASE_HOST,
            port=settings.DATABASE_PORT,
            dbname=settings.DATABASE_NAME,
            user=settings.DATABASE_USER,
            password=settings.DATABASE_PASSWORD,
        )

        cursor = connection.cursor()

        cursor.execute("""select id, title, displayname, text, post_created_at at time zone 'UTC' || '+00' as post_created_utc, creationdate at time zone 'UTC' || '+00' as creationdate, diff, avg(diff) over (partition by id order by creationdate) as average
from (
    select distinct p.id, u.displayname as displayname, p.title, c.text, c.creationdate, p.creationdate as post_created_at,
                    coalesce((c.creationdate - lag(c.creationdate) over (partition by c.postid order by c.creationdate)), c.creationdate - p.creationdate) as diff
    from (
        select p.id, p.title, p.creationdate
        from comments as c
        join posts as p on c.postid = p.id
        join post_tags as pt on p.id = pt.post_id
        join tags as t on pt.tag_id = t.id
        where t.tagname = %s
        group by p.id, p.title
        having count(distinct c.id) > %s
    ) as p
    join comments as c on p.id = c.postid
    left join users as u on c.userid = u.id
) as subquery
order by subquery.creationdate;
""", (tag, count))

        db_version = cursor.fetchall()

        cursor.close()
        connection.close()

        return db_version

    except Exception as e:
        return str(e)

@router.get("/v3/tags/{tag}/comments")
async def status(tag: str = Path(...), count: int = Query(...)):
    users = get_2_query(tag, count)

    json_users = []
    for user in users:

        json_user = {
            "post_id": user[0],
            "title": user[1],
            "displayname": user[2],
            "text": user[3],
            "post_created_at": user[4],
            "created_at": user[5],
            "diff": str(user[6]),
            "avg": str(user[7])
        }
        json_users.append(json_user)

    return {'items': json_users}



def get_3_query(tag: str, position: int, limit: int):
    try:
        connection = psycopg2.connect(
            host=settings.DATABASE_HOST,
            port=settings.DATABASE_PORT,
            dbname=settings.DATABASE_NAME,
            user=settings.DATABASE_USER,
            password=settings.DATABASE_PASSWORD,
        )

        cursor = connection.cursor()

        cursor.execute("""select c_id, u.displayname, body, text, score, rn
from(
SELECT c.id as c_id, p.body as body, c.text as text, c.score as score, p.creationdate as date, c.userid as cu_id,
       ROW_NUMBER() OVER (PARTITION BY p.id ORDER BY c.creationdate) AS rn
FROM comments AS c
 JOIN posts AS p ON c.postid = p.id
 JOIN post_tags AS pt ON p.id = pt.post_id
 JOIN tags AS t ON pt.tag_id = t.id
WHERE t.tagname = %s
AND c.creationdate > p.creationdate
) as sq
left join users as u on cu_id = u.id
where rn = %s
order by date
limit %s""", (tag, position, limit))

        db_version = cursor.fetchall()

        cursor.close()
        connection.close()

        return db_version

    except Exception as e:
        return str(e)

@router.get("/v3/tags/{tag}/comments/{position}")
async def status(tag: str = Path(...), position: int = Path(...), limit: int = Query(...,)):
    users = get_3_query(tag, position, limit)
    json_users = []
    for user in users:

        json_user = {
            "id": user[0],
            "displayname": user[1],
            "body": user[2],
            "text": user[3],
            "score": user[4],
            "position": user[5]
        }
        json_users.append(json_user)

    return {'items': json_users}

#4#####################################################################################################


def get_4_query(postid: int, limit: int):
    try:
        connection = psycopg2.connect(
            host=settings.DATABASE_HOST,
            port=settings.DATABASE_PORT,
            dbname=settings.DATABASE_NAME,
            user=settings.DATABASE_USER,
            password=settings.DATABASE_PASSWORD,
        )

        cursor = connection.cursor()

        cursor.execute("""
(select distinct u.displayname, p.body, p.creationdate at time zone 'UTC' || '+00' as creationdate from users as u
join posts as p on p.owneruserid = u.id
where p.id = %s
order by creationdate
) union all
(
select distinct u.displayname, p.body, p.creationdate at time zone 'UTC' || '+00' as creationdate from users as u
join posts as p on p.owneruserid = u.id
where p.parentid = %s
order by creationdate
)
limit %s""", (postid, postid, limit))

        db_version = cursor.fetchall()

        cursor.close()
        connection.close()

        return db_version

    except Exception as e:
        return str(e)

@router.get("/v3/posts/{postid}")
async def status(postid: int = Path(...), limit: int = Query(...,)):
    users = get_4_query(postid, limit)


    json_users = []
    for user in users:

        json_user = {
            "displayname": user[0],
            "body": user[1],
            "created_at": user[2]
        }
        json_users.append(json_user)

    return {'items': json_users}

