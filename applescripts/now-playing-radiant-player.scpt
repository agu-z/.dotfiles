#!/usr/bin/osascript

if application "Radiant Player" is running then
  tell application "Radiant Player"
    if exists current song name then
      set theName to current song name
      set theArtist to current song artist
      return "♫ " & theName & " - " & theArtist
    end if
  end tell
end if
