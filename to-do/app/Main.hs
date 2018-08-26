module Main (main) where

import Options.Applicative

type ItemIndex = Int

-- This makes more sense as it is a maybe of type String
-- Could be something we may have it or not
-- Crafting what an interpretere could look like is not something
-- I want to do
type ItemDescription = Maybe String

data Options = Options FilePath ItemIndex ItemDescription deriving Show

defaultDataPath:: FilePath
defaultDataPath = "~/.to-do.yaml"

optionsParser :: Parser Options
optionsParser = Options
    <$>dataPathParser
    <*>itemIndexParser
    <*>itemDescriptionParser

dataPathParser:: Parser FilePath
dataPathParser = strOption $
    value defaultDataPath
    <> long "data-path"
    <> short 'p'
    <> metavar "DATAPATH"
    <> help ("path to data file(default " ++defaultDataPath++ ")")

itemIndexParser:: Parser ItemIndex
itemIndexParser = argument auto(metavar "ITEMINDEX" <> help "index of item")

itemDescriptionParser:: Parser ItemDescription
itemDescriptionParser =
    Just <$> itemDescriptionValueParser
    <|> flag' Nothing (long "clear-desc") -- What happens when we pass a clear desc function here

main::IO()
main = do
      options <- execParser(info (optionsParser) (progDesc "To-Do list manager"))
      putStrLn $ "options = "++ show options
