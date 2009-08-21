
get '/jspec/*' do |path|
  send_file JSPEC_ROOT + '/lib/' + path
end

post '/results' do
  require 'json'
  data = JSON.parse request.body.read
  if data['options'].include?('verbose') && data['options']['verbose']
    puts "\n\n %s Passes: %s Failures: %s\n\n" % [bold(browser_name), green(data['stats']['passes']), red(data['stats']['failures'])]
    data['results'].compact.each do |suite|
      puts "\n " + bold(suite['description'])
      suite['specs'].compact.each do |spec|
        case spec['status'].to_sym
        when :pass 
          next if data['options'].include?('failuresOnly') && data['options']['failuresOnly']
          puts '  ' + green(spec['description']) + assertion_graph_for(spec['assertions']).to_s
        when :fail
          puts '  ' + red(spec['description'])
          puts '  ' + spec['message'] + "\n\n" if spec['message']
        else
          puts '  ' + blue(spec['description'])
        end
      end
    end
  else
    puts "%20s Passes: %s Failures: %s" % [bold(browser_name), green(data['stats']['passes']), red(data['stats']['failures'])]
  end
  halt 200
end

get '/*' do |path|
  pass unless File.exists?(path)
  send_file path
end

#--
# Simulation Routes
#++

get '/slow/*' do |seconds|
  sleep seconds.to_i
end

get '/status/*' do |code|
  halt code.to_i
end
