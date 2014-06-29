%w(rubygems
   sinatra
   espeak
   digest/sha1).each { |l| require l }

include ESpeak

set :public_folder, "#{Dir.pwd}/public"
folder = "#{Dir.pwd}/public/tmp/"

get '/' do
  if params[:text]
    filename = "#{Digest::SHA1.hexdigest(params.to_s)}.mp3"
    ESpeak::Speech.new(params[:text]).save(folder + filename) unless
      File.exists? folder + filename
    @filename = filename
  end

  erb :index
end

# get '/tmp/:filename' do
#   [200, {'Content-type' => 'audio/mpeg'},
#     File.read("#{folder}#{params[:filename]}")]
# end
