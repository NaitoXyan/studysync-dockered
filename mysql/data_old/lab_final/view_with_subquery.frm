TYPE=VIEW
query=select `lab_final`.`person`.`person_id` AS `person_id`,`lab_final`.`person`.`name` AS `name` from `lab_final`.`person` where `lab_final`.`person`.`person_id` = (select `lab_final`.`travelandcost`.`travel_id` from `lab_final`.`travelandcost` where `lab_final`.`travelandcost`.`travel_id` = 1)
md5=b96d6694550c8c0e97acbe41252066e5
updatable=1
algorithm=0
definer_user=root
definer_host=localhost
suid=2
with_check_option=0
timestamp=0001686391379569350
create-version=2
source=SELECT person.person_id, person.name FROM\nperson WHERE person.person_id = (SELECT travelandcost.travel_id FROM travelandcost WHERE travelandcost.travel_id = 1)
client_cs_name=utf8mb4
connection_cl_name=utf8mb4_unicode_ci
view_body_utf8=select `lab_final`.`person`.`person_id` AS `person_id`,`lab_final`.`person`.`name` AS `name` from `lab_final`.`person` where `lab_final`.`person`.`person_id` = (select `lab_final`.`travelandcost`.`travel_id` from `lab_final`.`travelandcost` where `lab_final`.`travelandcost`.`travel_id` = 1)
mariadb-version=100427
