SELECT a.topic_id,a.topic_name,a.topic_parent AS parent_id,b.topic_name AS parent_name
FROM topics AS a,topics AS b
WHERE a.topic_parent = b.topic_id;