#!/usr/bin/env bash
# Inspired by Patrick Stadler's script (https://github.com/pstadler/ticker.sh)
#
# <bitbar.title>Yahoo Stock Ticker</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Long Do</bitbar.author>
# <bitbar.author.github>longpdo</bitbar.author.github>
# <bitbar.desc>Shows major stock indices in the menu bar and stock symbols in the dropdown menu.</bitbar.desc>
# <bitbar.image></bitbar.image>
# <bitbar.dependencies>bash,coreutils</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/longpdo/bitbar-plugins-custom</bitbar.abouturl>
#
# by longpdo (https://github.com/longpdo)

LANG=C
export PATH='/usr/local/bin:/usr/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH'

INDICES=('^DJI' '^GSPC' '^IXIC' '^GDAXI' '^FTSE' '^FCHI' '^STOXX50E')
STOCKS=("AAPL" "APC.F" "AMZN" "T" "ACB")

if ! $(type jq > /dev/null 2>&1); then
  echo "'jq' is not in the PATH."
  exit 1
fi

if [ -z "$NO_COLOR" ]; then
  : "${COLOR_GREEN:=\e[32m}"
  : "${COLOR_RED:=\e[31m}"
  : "${COLOR_RESET:=\e[00m}"
fi

FIELDS=(symbol shortName marketState regularMarketTime regularMarketPrice regularMarketChangePercent \
  fullExchangeName currency regularMarketPreviousClose regularMarketOpen bid ask regularMarketDayRange \
  fiftyTwoWeekRange fiftyDayAverage twoHundredDayAverage fiftyDayAverageChangePercent twoHundredDayAverageChangePercent)
SYMBOLS=("${INDICES[@]}" "${STOCKS[@]}")
symbols=$(IFS=,; echo "${SYMBOLS[*]}")
fields=$(IFS=,; echo "${FIELDS[*]}")
API_ENDPOINT="https://query1.finance.yahoo.com/v7/finance/quote?fields=$fields&symbols=$symbols"
results=$(curl --silent "$API_ENDPOINT" | jq '.quoteResponse .result')

query () {
  echo $results | jq -r ".[] | select(.symbol == \"$1\") | .$2"
}

get_index_name () {
  case $1 in
    ^GSPC)
      printf '🇺🇸 S&P 500'
      ;;
    ^DJI)
      printf '🇺🇸 DOW 30'
      ;;
    ^IXIC)
      printf '🇺🇸 NASDAQ'
      ;;
    ^GDAXI)
      printf '🇩🇪 DAX'
      ;;
    ^FTSE)
      printf '🇬🇧 FTSE 100'
      ;;
    ^FCHI)
      printf '🇫🇷 CAC 40'
      ;;
    ^STOXX50E)
      printf '🇪🇺 EURO STOXX 50'
      ;;
  esac
}

# MENU BAR
for symbol in $(IFS=' '; echo "${INDICES[*]}" | tr '[:lower:]' '[:upper:]'); do
  marketState="$(query $symbol 'marketState')"

  if [ -z $marketState ]; then
    printf 'No results for symbol "%s"\n' $symbol
    continue
  fi

  if [ $marketState != "REGULAR" ]; then
    color=
    marketSign='●'
    percent=0.00
  fi

  if [ $marketState == "REGULAR" ]; then
    name=$(query $symbol 'shortName')
    percent=$(query $symbol 'regularMarketChangePercent')

    if ( echo $percent | grep -q ^- ); then
      color=$COLOR_RED
      marketSign='▼'
    else
      color=$COLOR_GREEN
      marketSign='▲'
    fi
  fi

  printf "$(get_index_name $symbol)"
  printf " $color(%.2f%%)" $percent
  printf " %s$COLOR_RESET" $marketSign
  echo "| dropdown=false"
done

# DROPDOWN INFO
echo "---"
for symbol in $(IFS=' '; echo "${STOCKS[*]}" | tr '[:lower:]' '[:upper:]'); do
  marketState="$(query $symbol 'marketState')"

  if [ -z $marketState ]; then
    printf 'No results for symbol "%s"\n' $symbol
    continue
  fi

  name=$(query $symbol 'shortName')
  time=$(query $symbol 'regularMarketTime')
  exchange=$(query $symbol 'fullExchangeName')
  currency=$(query $symbol 'currency')
  price=$(query $symbol 'regularMarketPrice')
  percent=$(query $symbol 'regularMarketChangePercent')
  close=$(query $symbol 'regularMarketPreviousClose')
  open=$(query $symbol 'regularMarketOpen')
  bid=$(query $symbol 'bid')
  ask=$(query $symbol 'ask')
  dayRange=$(query $symbol 'regularMarketDayRange')
  fiftyTwoWeekRange=$(query $symbol 'fiftyTwoWeekRange')
  ma50=$(query $symbol 'fiftyDayAverage')
  ma200=$(query $symbol 'twoHundredDayAverage')
  ma50Change=$(query $symbol 'fiftyDayAverageChangePercent')
  ma200Change=$(query $symbol 'twoHundredDayAverageChangePercent')

  if [ $marketState != "REGULAR" ]; then
    marketSign='●'
    marketState='CLOSED'
    percent=0.00
  fi

  if [ $marketState == "REGULAR" ]; then
    marketState='OPEN'

    if ( echo $percent | grep -q ^- ); then
      color=$COLOR_RED
      marketSign='▼'
    else
      color=$COLOR_GREEN
      marketSign='▲'
    fi
  fi

  # MENU INFO
  printf "%-6s \t %-10.2f" "$(echo $symbol| cut -d'.' -f 1)" $price
  printf "\t$color(%.2f%%)" $percent
  printf " %s$COLOR_RESET\n" $marketSign
  # SUBMENU INFO
  printf "%s %s\n" "--" "$name"
  printf "%s %s - %s %s.\n" "--" $exchange "Currency in" $currency
  printf "%s %s - Market is %s.\n" "--" $(date -d @$time +"%T") $marketState
  printf "%s\n" "--"
  printf "%-20s\t%.2f\n" "--Previous Close:" $close
  printf "%-20s\t%.2f\n" "--Open:" $open
  printf "%-20s\t\t%.2f\n" "--Bid:" $bid
  printf "%-20s\t\t%.2f\n" "--Ask:" $ask
  printf "%-20s\t%s\n" "--Day's Range:" "$dayRange"
  printf "%-20s\t%s\n" "--52W Range:" "$fiftyTwoWeekRange"
  printf "%-20s\t%.2f (%.2f%%)\n" "--50 MA:" $ma50 $(echo "$ma50Change*100" | bc -l)
  printf "%-20s\t%.2f (%.2f%%)\n" "--200 MA:" $ma200 $(echo "$ma200Change*100" | bc -l)
done
