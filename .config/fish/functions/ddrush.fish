# Defined in - @ line 2
function ddrush
	docker-compose exec php drush -r /var/www/html/web $argv
end
