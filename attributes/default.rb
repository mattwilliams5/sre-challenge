default["apache"]["sites"]["matt-williams-52"] = { "site_title" => "SRE CHALLENGE ", "port" => 443, "domain" => "matt-williams-52.mylabserver.com" }

default["author"]["name"] = "matt"

# Future buildout for Centos recipe needs updating
case node["platform"]
when "centos"
	default["apache"]["package"] = "httpd"
when "ubuntu"
	default["apache"]["package"] = "apache2"
end
