sc_client_id = '2b9312964a1619d99082a76ad2d6d8c6'
et_client_id = '534872bc1c3389f658f335e241a25efd219fd144'

ParseMusic = {}
ParseMusic.search = (keyword, callback) ->
  #for service_name in ['soundcloud', 'youtube']
  #for service_name in ['youtube']
  for service_name in ['soundcloud']
    console.log service_name
    url = getApiUrl(service_name, keyword)
    $.get(url, (data) ->
      tracks = getTracks(service_name, data)
      res = []
      if tracks[0]
        for track in tracks
          res.push(getTrack(service_name, track))
        callback(res)
      else
        callback(res)
    )

getApiUrl = (service, keyword) ->
  {
    soundcloud: "http://api.soundcloud.com/tracks.json?client_id=#{sc_client_id}&q=#{keyword}&duration[from]=#{24*60*1000}"
    youtube: "http://gdata.youtube.com/feeds/api/videos?q=#{keyword}&filter=long&alt=json"
    mixcloud: "http://api.mixcloud.com/search/?q=#{keyword}&type=cloudcast"
  }[service]

getTracks = (service_name, data) ->
  params = {
    soundcloud: "data"
    youtube: "data.feed.entry"
  }
  eval("#{params[service_name]}")

getTrack = (service_name, track) ->
  params = {
    soundcloud: {
      id: 'id'
      title: 'title'
      picture: 'artwork_url'
      duration: 'duration'
      url: 'permalink_url'
    }
    youtube: {
      id: 'id'
      title: 'title.$t'
      picture: 'media$group.media$thumbnail[3].url'
      duration: 'media$group.yt$duration.seconds'
      is_second: true
      url: ''
    }
  }

  service = params[service_name]

  duration = parseInt(eval("track.#{service.duration}"))
  if service.is_second
    duration = duration * 1000

  return {
    id: eval("track.#{service.id}")
    title: eval("track.#{service.title}")
    picture: eval("track.#{service.picture}")
    duration: duration
    url: eval("track.#{service.url}")
  }

@ParseMusic = ParseMusic
