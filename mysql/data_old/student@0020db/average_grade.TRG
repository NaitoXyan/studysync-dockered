TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `top_student_trigger_delete` BEFORE INSERT ON `average_grade` FOR EACH ROW DELETE FROM top_student_table' 'CREATE DEFINER=`root`@`localhost` TRIGGER `top_student_trigger` AFTER INSERT ON `average_grade` FOR EACH ROW INSERT INTO top_student_table (student_id, grade, remarks)\n\nSELECT student_id, final_avg_grade, grade_remarks(final_avg_grade) \nFROM average_grade\nORDER BY average_grade.final_avg_grade DESC LIMIT 1'
sql_modes=1098907648 1098907648
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_unicode_ci' 'utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
created=1679494426425496 1679494456368606
