SELECT a.topic_id,a.topic_name,a.topic_parent AS parent_id,b.topic_name AS parent_name
FROM topics AS a,topics AS b
WHERE 
a.topic_id = 8 AND
a.topic_parent = b.topic_id;


SELECT q.question_id,q.question_name
FROM topics AS t,questions AS q
WHERE
(q.topic0 = 8 AND t.topic_id = 8) OR
(q.topic1 = 8 AND t.topic_id = 8) OR
(q.topic2 = 8 AND t.topic_id = 8) OR
(q.topic3 = 8 AND t.topic_id = 8) OR
(q.topic4 = 8 AND t.topic_id = 8);