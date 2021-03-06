-- get articles without datepublished
SELECT * FROM feedarticle WHERE datepublished IS NULL

-- filter by datespublished range
SELECT url, datepublished, datesaved FROM feedarticle WHERE datepublished > '2015-12-10 00:00:01' AND datepublished < '2015-12-10 23:59:59'
AND url LIKE '%jutarnji.hr%' ORDER BY datesaved DESC

-- select articles within a date range from a set of feeds
SELECT url, datesaved, datepublished, text FROM feedarticle WHERE 
	(datepublished > '2015-12-10 00:00:01' AND
	 datepublished < '2015-12-10 23:59:59')
	AND 
	(id IN (SELECT DISTINCT art.id AS feed_id FROM feedarticle AS art 
	JOIN (
	SELECT DISTINCT articles_id, feeds_id FROM feedarticle_feed WHERE feeds_id IN 
		( SELECT id FROM feed WHERE url IN 
		  ('http://www.tportal.hr/vijesti/hrvatska/' ) )
	) AS t ON art.id = t.articles_id))

SELECT * FROM feedarticle WHERE 
	(datepublished > '2015-12-11 00:00:01' AND
	 datepublished < '2015-12-11 23:59:59')
	AND 
	(id IN (SELECT DISTINCT art.id AS feed_id FROM feedarticle AS art 
	JOIN (
	SELECT DISTINCT articles_id, feeds_id FROM feedarticle_feed WHERE feeds_id IN 
		( SELECT id FROM feed WHERE url IN 
		  ('http://www.jutarnji.hr/rss?type=section&id=10' ) )
	) AS t ON art.id = t.articles_id))

-- article corpus date cutoff filter:
SELECT datepublished, datesaved FROM feedarticle WHERE 
	datepublished > '2015-01-26 00:00:00' OR
	(datepublished IS NULL AND datesaved > '2015-01-26 00:00:00')
	ORDER BY datepublished, datesaved
--- same corpus, count num. articles
SELECT count(*) FROM feedarticle WHERE 
	datepublished > '2015-01-26 00:00:00' OR
	(datepublished IS NULL AND datesaved > '2015-01-26 00:00:00')	
	
-- get feed ids for feed urls	
SELECT id FROM feed WHERE url IN ('http://www.theguardian.com/us-news/rss', 'http://rss.cnn.com/rss/cnn_us.rss')
	AND EXISTS 
)

-- get short texts
select a.url, a.text from feedarticle a where length(a.text) < 150

-- get articles per outlet counts
select o.name, count(a.id) 
from outlet o
left join feed f on f.outlet_id = o.id
left join feedarticle_feed ff on ff.feeds_id = f.id
left join feedarticle a on a.id = ff.articles_id
group by o.name

-- get ids of all articles from a set of feeds
SELECT DISTINCT art.id FROM feedarticle AS art 
JOIN (
SELECT DISTINCT articles_id, feeds_id FROM feedarticle_feed WHERE feeds_id IN 
	( SELECT id FROM feed WHERE url IN 
	  ('http://www.theguardian.com/us-news/rss', 
	  'http://rss.cnn.com/rss/cnn_us.rss') )
) AS t
ON art.id = t.articles_id
ORDER BY art.id

-- query with both conditions: datesaved and id from set of feeds
SELECT setseed(0.1);
SELECT * FROM feedarticle WHERE 
	(datepublished > '2015-01-26 00:00:00' OR
	(datepublished IS NULL AND datesaved > '2015-01-26 00:00:00'))
	AND 
	(id IN (SELECT DISTINCT art.id AS feed_id FROM feedarticle AS art 
	JOIN (
	SELECT DISTINCT articles_id, feeds_id FROM feedarticle_feed WHERE feeds_id IN 
		( SELECT id FROM feed WHERE url IN 
		  ('http://www.theguardian.com/us-news/rss', 
		  'http://rss.cnn.com/rss/cnn_us.rss') )
	) AS t ON art.id = t.articles_id))
	ORDER BY random()

--- test for previous query - just return all the feeds for a list of article ids, 
---    insert previous select in parantheses below, may return more feeds because
---	some articles occur in more than one feed
SELECT setseed(0.1);
SELECT DISTINCT feeds_id FROM feedarticle_feed WHERE articles_id IN
(

) ORDER BY feeds_id	


-- group (count) and ouder by day
select to_char(date_trunc('day', datesaved), 'YYYY-MM-DD') as datetrunc, 
	count(id) FROM feedarticle
GROUP BY datetrunc
ORDER BY datetrunc
