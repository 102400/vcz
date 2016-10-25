SELECT 
q.question_name,q.question_content,q.question_author,anonymous,u.nickname,q.create_time,q.answer_count,q.view_count,
q.topic0 AS topic0_id,
q.topic1 AS topic1_id,
q.topic2 AS topic2_id,
q.topic3 AS topic3_id,
q.topic4 AS topic4_id
FROM questions AS q,users AS u
WHERE
q.question_id = 1 AND
u.user_id = question_author



SELECT t.topic_name
FROM questions AS q,topics AS t
WHERE
question_id = 1 AND
(
	q.topic0 = t.topic_id 
     OR q.topic1 = t.topic_id 
	 OR q.topic2 = t.topic_id 
	 OR q.topic3 = t.topic_id 
	 OR q.topic4 = t.topic_id 
)