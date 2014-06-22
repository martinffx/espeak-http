%w(rubygems
   sinatra
   espeak-ruby
   digest/sha1).each { |l| require l }

include ESpeak

get '/' do
  if params[:text]
    filename = "/tmp/#{Digest::SHA1.hexdigest(params.to_s)}.mp3"
    espeak(filename, params) unless File.exists? filename
    @filename = filename
  end

  erb :index
end

get '/tmp/:filename' do
  [200, {'Content-type' => 'audio/mpeg'},
    File.read("/tmp/#{params[:filename]}")]
end
