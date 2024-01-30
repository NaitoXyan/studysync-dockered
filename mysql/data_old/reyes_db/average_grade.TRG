TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `top_student_trigger` AFTER INSERT ON `average_grade` FOR EACH ROW BEGIN\n\nDELETE FROM top_student_table;\n\nINSERT INTO top_student_table (student_id, grade, remarks)\n\nSELECT student_id, final_avg_grade, grade_remarks(final_avg_grade) \nFROM average_grade;\n\nDELETE FROM top_student_table \nWHERE (grade < (SELECT MAX(grade) FROM top_student_table));\n\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `top_student_trigger_after_update` AFTER UPDATE ON `average_grade` FOR EACH ROW BEGIN\n\nDELETE FROM top_student_table;\n\nINSERT INTO top_student_table (student_id, grade, remarks)\n\nSELECT student_id, final_avg_grade, grade_remarks(final_avg_grade) \nFROM average_grade;\n\nDELETE FROM top_student_table \nWHERE (grade < (SELECT MAX(grade) FROM top_student_table));\n\nEND'
sql_modes=524288 524288
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
db_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
created=1686326077205895 1686326077217206
