create table social_media_engagement(
    post_id text,
	platform text,
	post_type text,
	post_time text,
	likes int,
	comments int,
	shares int,
	post_day text,
	sentiment_score text
	
)
select * from social_media_engagement

--total number of posts
select count(post_id) from social_media_engagement


--posts by platform
select platform,count(post_id) as totalposts
from social_media_engagement
group by platform

--posts by post
select post_type, count(post_id) 
from social_media_engagement
group by post_type

--positive vs negetive
select sentiment_score, count(post_id)
from social_media_engagement
group by sentiment_score

---sum
select sum(likes) as totallikes, sum(comments) as totalcomments,
       sum(shares) as totalshares
from social_media_engagement

--total engagement
select post_id,(likes+comments+shares) as total_engagement
from social_media_engagement

--avg
select post_id, (likes+comments+shares)/3 as avg_engagement
from social_media_engagement

--Which platform has the highest total engagement?
select platform, max(likes+comments+shares)
from social_media_engagement
group by platform

--Which post type has the highest total engagement?
select post_type, sum(likes+comments+shares) as sum
from social_media_engagement
group by post_type
order by sum desc

--Which day of the week has the highest total engagement?
select post_day, sum(likes+comments+shares) as sum
from social_media_engagement
group by post_day
order by sum desc

--How does sentiment relate to engagement?
select sentiment_score, sum(likes+comments+shares) as total_engagement
from social_media_engagement
group by sentiment_score

--Which platform + post type combination has the highest total engagement?
select platform, post_type, sum(likes+comments+shares) as total_engagement
from social_media_engagement
group by platform, post_type

--What are the top 10 posts by total engagement?
select post_id,sum(likes+comments+shares) as total_engagement
from social_media_engagement
group by post_id
order by total_engagement desc
limit 10

--Find the top 3 posts by engagement within each platform.
with cte as(
select post_id,platform,likes+comments+shares as total_engagemnet
from social_media_engagement)

,ab as(select post_id,platform,total_engagemnet,dense_rank() over(partition by platform order by total_engagemnet desc) as rn
from cte)

select * from ab
where rn<=3

--Find the posts whose total engagement is higher than the overall 
--average engagement of all posts.
select post_id, likes+comments+shares as total_engagement
from social_media_engagement
where likes+comments+shares>(select avg(likes+comments+shares)
from social_media_engagement)

--What is the total engagement for each month?
select extract(month from(to_date(REPLACE(SPLIT_PART(post_time, ' ', 1), '-', '/'),
'mm/dd/yyyy'))) as month,
   sum(likes+comments+shares) as summation
from social_media_engagement
group by month
order by month desc

--Which month had the highest total engagement?
select extract(month from(to_date(REPLACE(SPLIT_PART(post_time, ' ', 1), '-', '/'),
'mm/dd/yyyy'))) as month, sum(likes+comments+shares) as a
from social_media_engagement
group by month
order by a desc
limit 1





