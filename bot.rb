require('telegram/bot')
require_relative('lib/command/nekonime')

token = 'YOUR_TOKEN_HERE'

$ytmp3_request = nil

def command(bot, message)
  id = message.chat.id

  client = bot.api

  case message.text
  when '/start'
    client.send_message(
      chat_id: id,
      text: "Hello, #{message.from.first_name}"
    )
  when '/stop'
    client.send_message(
      chat_id: id,
      text: "Bye, #{message.from.first_name}"
    )
  when '/nekonime'
    neko = Neko.new.display_neko
    client.send_photo(
      chat_id: id,
      photo: neko
    )
  end
  when '/ytmp3'
    $ytmp3_request = true
    client.send_message(
      chat_id: id,
      text: "Send the youtube url!"
    )
  else
    if $ytmp3_request
      url = message.text
      if url.include? "http"
        data = Ytmp3.new.display_ytmp3(url)
        title = data['title']
        thumb = data['thumb']
        size = data['size']
        audioUrl = data['download_audio']
        client.send_photo(
          chat_id: id,
          photo: thumb,
          caption: "- Title: #{title}\n- Size: #{size}\n\nWait a moment"
        )
        client.send_audio(
          chat_id: id,
          audio: audioUrl,
          caption: "This is your mp3."
        )
      else
        client.send_message(
          chat_id: id,
          text: "Your url is invalid!"
        )
      end
    else
      client.send_message(
        chat_id: id,
        text: 'I do not recognize that command'
      )
    end
  end
end

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    command(bot, message)
  end
end
