import Config

config :advent_of_code, AdventOfCode.Input,
  session_cookie: System.get_env("ADVENT_OF_CODE_SESSION_COOKIE")
