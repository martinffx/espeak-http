%w(rubygems
   sinatra
   espeak
   pry-byebug
   digest/sha1).each { |l| require l }

include ESpeak

set :public_folder, "#{Dir.pwd}/public"
folder = "#{Dir.pwd}/public/tmp/"

get '/' do
  if params[:text]
    filename = "#{Digest::SHA1.hexdigest(params.to_s)}.mp3"
    binding.pry
    ensure_tmp_folder(folder)
    ESpeak::Speech.new(params[:text]).save(folder + filename) unless
      File.exists? folder + filename
    @filename = filename
  end

  erb :index
end


def ensure_tmp_folder(folder)
  Dir.mkdir(folder) unless Dir.exists? folder
end
