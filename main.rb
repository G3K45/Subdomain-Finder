require 'httparty'
require 'rainbow'


def banner
  puts Rainbow(" _______  __   __  _______  ______   _______  __   __  _______  ___   __    _ ").cyan   
  puts Rainbow("|       ||  | |  ||  _    ||      | |       ||  |_|  ||   _   ||   | |  |  | |").cyan 
  puts Rainbow("|  _____||  | |  || |_|   ||  _    ||   _   ||       ||  |_|  ||   | |   |_| |").cyan  
  puts Rainbow("| |_____ |  |_|  ||       || | |   ||  | |  ||       ||       ||   | |       |").cyan  
  puts Rainbow("|_____  ||       ||  _   | | |_|   ||  |_|  ||       ||       ||   | |  _    |").cyan  
  puts Rainbow(" _____| ||       || |_|   ||       ||       || ||_|| ||   _   ||   | | | |   |").cyan  
  puts Rainbow("|_______||_______||_______||______| |_______||_|   |_||__| |__||___| |_|  |__|").cyan  
end 

def s_banner
  puts Rainbow(" _______  __   __  ___   _______ ").red 
  puts Rainbow("|       ||  |_|  ||   | |       |").red
  puts Rainbow("|    ___||       ||   | |_     _|").red
  puts Rainbow("|   |___ |       ||   |   |   |  ").red 
  puts Rainbow("|    ___| |     | |   |   |   |  ").red
  puts Rainbow("|   |___ |   _   ||   |   |   |  ").red 
  puts Rainbow("|_______||__| |__||___|   |___|  ").red  
end

def exit
   puts "Do you want to exit the program?"
   puts "[y]yes [n]no:"
   option = gets.chomp
   if option == "y"
      system("clear")
      s_banner()
   else
      system("clear")
      main()
   end 
end

def main
  banner()
  $s_code = 200
  $e_code = 404
  $m_code = 301
  $b_code = 400
  $f_code = 403
  x = 0
  puts "Enter filename or directory of subdomains[+]:"
  dir = gets.chomp
  if File.exist?(dir)
    puts "Enter IP or URL:"
    ipu = gets.chomp
    requ = HTTParty.get(ipu)
    if requ.code == $s_code
       file = File.open(dir, "r") do |file|
         file.readlines.each do |word|
            payload = word.strip!
            resp = HTTParty.get(ipu+"/"+payload)
            if resp.code == $s_code
               puts ipu+"/"+payload+",Subdomain found, HTTP Response Code:200"
            elsif resp.code == $e_code
               puts ""
            elsif resp.code == $m_code
               puts ipu+"/"+payload+",Subdomain moved, HTTP Response Code:301"
            elsif resp.code == $b_code
               puts "Bad Code, HTTP Response Code:400"
            elsif resp.code == $f_code
               puts ipu+"/"+payload+",Subdomain found,but you dont have access to it, HTTP Response Code:403"
            end
         end
       end
       exit()
    else
      system("clear")
      puts "Error, HTTP Response Code:"+requ.code.to_s
      main()
    end
  else
    system("clear")
    puts "File does not exist"
    puts "Please enter a file that exists"
    main()
  end
end

main()
