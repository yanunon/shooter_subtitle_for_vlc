#! /usr/bin/env lua
--
-- vlc_shooter_subtitles.lua
-- Copyright (C) 2013 Yang Junyong <yanunon@gmail.com>
--
-- Distributed under terms of the MIT license.
--
is_downloading = false

function descriptor()
	return {title="Shooter Subtitles";
		version="0.1";
		author="yanunon";
		capabilities={"input-listener", "meta-listener"};
	}
end

function activate()
	vlc.msg.dbg("activate")
end

function deactivate()
	vlc.msg.dbg("deactivate")
end

function close()
	vlc.deactivate()
end

function get_input_path()
	local item = vlc.item or vlc.input.item()
	if not item then
		return false
	else
		--local parsed_uri = vlc.net.url_parse(item:uri())
		--local path = vlc.strings.decode_uri(parsed_uri["path"])
		local path = item:uri()
		vlc.msg.dbg(path)
		return path
	end
end

function meta_changed()
	return false
end

function input_changed()
	if not is_downloading then
		movie_path = get_input_path()
		if movie_path then
			vlc.msg.dbg('input_changed\n'..movie_path)
			is_downloading = true
			local pro = io.popen('~/.local/share/vlc/lua/extensions/download_shooter_subtitles.py '..movie_path)
			if pro then
				local subtitle = pro:read('*all')
				pro:close()
				vlc.msg.dbg('shooter cn\n')
				vlc.msg.dbg(subtitle)
				if subtitle ~= 'note found' then
					subtitle = string.gsub(subtitle, '\n', '')
					vlc.input.add_subtitle(subtitle)
				end
			end
			is_downloading = false
		end
	end	
end
