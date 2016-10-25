SELECT a.answer_id,a.user_id,u.user_nickname,a.answer_content,a.anonymous,l.license_name,a.answer_weight,a.agree_count,a.disagree_count,a.create_time
FROM answers AS a,licenses AS l,users AS u
WHERE question_id = 1
AND a.license = l.license_id
AND a.user_id = u.user_id;