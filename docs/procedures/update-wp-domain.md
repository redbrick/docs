
# Update a WordPress Domain - `wizzdom`, `distro`

Redbrick hosts a variety of services and websites for various clubs and societies in DCU. Oftentimes these websites hosted for societies run on WordPress due to it's ease of use. 
However, what happens when you no longer have access to the domain? You can change the domain on the webserver however WordPress will redirect you to the old domain. In this case you must update the database to change the domain. This happened with TheCollegeView in 2023, you can read more about that [here](https://github.com/redbrick/open-governance/tree/master/admin/)
## SQL Commands

> [!WARNING] BACKUPS!!!
> Ensure you have a recent backup of the database by checking `/storage/backups`

- First, check what the current value is
```sql
-- validate current setting
select option_name,option_value from wp_2options where( option_name="siteurl" or option_name="home");
```

- Now, update the option with the new value
```sql
-- update to new value
update wp_2options set option_value="http://www.thecollegeview.redbrick.dcu.ie" where( option_name="siteurl" or option_name="home");
```

- Verify that the new value is set correctly
```sql
-- validate new value
select option_name,option_value from wp_2options where( option_name="siteurl" or option_name="home");
```

- Now, the same again but for the post content and guid
```sql
-- update post content with new domain
update wp_2posts set post_content = replace(post_content,"://www.thecollegeview.com/","://thecollegeview.redbrick.dcu.ie/");

-- update the guid with the new domain
update wp_2posts set guid = replace(guid,"://www.thecollegeview.com/","://thecollegeview.redbrick.dcu.ie/");
```