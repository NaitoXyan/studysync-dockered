TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `add_money` AFTER INSERT ON `person` FOR EACH ROW BEGIN \n\nINSERT INTO person_balance (person_id,balance,have_money)\n\nSELECT person_id, balance, \'yes\' FROM person\nWHERE balance IS NOT NULL;\n\nEND' 'CREATE DEFINER=`root`@`localhost` TRIGGER `update_money` AFTER UPDATE ON `person` FOR EACH ROW BEGIN \n\nDELETE FROM person_balance;\n\nINSERT INTO person_balance (person_id,balance,have_money)\n\nSELECT person.person_id, person.balance, \'yes\' FROM person\nWHERE person.balance IS NOT NULL;\n\n\nEND'
sql_modes=1098907648 1098907648
definers='root@localhost' 'root@localhost'
client_cs_names='utf8mb4' 'utf8mb4'
connection_cl_names='utf8mb4_unicode_ci' 'utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci' 'utf8mb4_general_ci'
created=1686390069140935 1686390672040219
