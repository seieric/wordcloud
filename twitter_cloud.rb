require 'twitter'
require './env/twitter_config'

class TwitterCloud < Twitter
  def initialize()
    @init = REST::Client.new do |c|
      c.consumer_key = CK
      c.consumer_secret = CS
      c.access_token = AT
      c.access_token_secret = AS
    end
  end

  def get(user_name, count)
    epoc_count = (count / 200) + 1 #1リクエストで200ツイートがが限界、繰り返し
    tweets = [@init.user_timeline(username, {count: 1})][0] #最新の投稿を配列で取得

    epoc_count.times do
      @init.user_timeline(username, {count: 200, max_id: tweets[-1].id-1}).each do |t|
        break if tweets.size == count
        @tweets << t
      end
    end

    self.format!()
  end

  def format!()
    @tweets = @tweets.map!{|t| t.text}.reject!{|t| t.include?("RT")} #ツイート本文のみRTを削除
  end
  protected :format

end
