%w(rubygems
   sinatra
   espeak
   digest/sha1).each { |l| require l }

include ESpeak

get '/' do
  if params[:text]
    filename = "/tmp/#{Digest::SHA1.hexdigest(params.to_s)}.mp3"
    ESpeak::Speech.new(params[:text]).save(filename) unless File.exists? filename
    @filename = filename
  end

  erb :index
end

get '/tmp/:filename' do
  [200, {'Content-type' => 'audio/mpeg'},
    File.read("/tmp/#{params[:filename]}")]
end
