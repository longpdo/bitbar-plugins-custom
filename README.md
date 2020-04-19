# BitBar-Plugins-Custom <!-- omit in toc -->

> Collection of BitBar plugins I wrote myself or tweaked to my liking.

[![Open Issues](https://badgen.net/github/open-issues/longpdo/bitbar-plugins-custom)](https://github.com/longpdo/bitbar-plugins-custom/issues)
[![License](https://badgen.net/github/license/longpdo/bitbar-plugins-custom)](LICENSE)

[Report Bug](https://github.com/longpdo/bitbar-plugins-custom/issues) · [Request Feature](https://github.com/longpdo/bitbar-plugins-custom/issues)

<!-- TABLE OF CONTENTS -->
## Table of Contents <!-- omit in toc -->

* [About The Project](#about-the-project)
  * [Plugins I am currently using](#plugins-i-am-currently-using)
  * [Plugins I wrote](#plugins-i-wrote)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)
* [Acknowledgements](#acknowledgements)

<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Screenshot][product-screenshot]](https://github.com/longpdo/bitbar-plugins-custom)

This repo contains scripts, programs and command-line tools that add functionality to [BitBar](https://github.com/matryer/bitbar#get-started).

### Plugins I am currently using

* [Clock with calendar](https://getbitbar.com/plugins/Time/CalendarLite.1m.sh)
  * Tweaked the format of the date displayed in the menu bar
[![CalenderLite Screenshot][calendarlite-screenshot]](https://github.com/longpdo/bitbar-plugins-custom/blob/master/plugins/CalendarLite.1s.sh)
* [Clipboard History](https://getbitbar.com/plugins/System/clipboard-history.3s.sh)
* [Colorful Battery Indicator](https://getbitbar.com/plugins/System/ColorfulBatteryLevel.5s.sh)
  * Added the remaining time to show in the menu bar, when the battery is discharging
* [Countdown Timer 2](https://getbitbar.com/plugins/Time/countdown_timer_2.1s.py)
* [Yahoo Weather](https://getbitbar.com/plugins/Weather/yahoo-weather.5m.py)
  * Simplified to only show the temperature in the menu bar
  * Added weather forecast for the next days in the dropdown view
[![Yahoo Weather Screenshot][yahoo-weather-screenshot]](https://github.com/longpdo/bitbar-plugins-custom/blob/master/plugins/yahoo-weather.1h.py)

### Plugins I wrote

* [Social Media Stats](https://github.com/longpdo/bitbar-plugins-custom/blob/master/deactivated-plugins/social_media_stats.1h.py)
  * Shows YouTube subscribers, Facebook likes, Instagram and Twitter followers.
[![Social Media Stats Screenshot][social-media-stats-screenshot]](https://github.com/longpdo/bitbar-plugins-custom/blob/master/plugins/yahoo-weather.1h.py)

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

* BitBar

```sh
# Install via brew on macOS
brew cask install bitbar
```

Or download .app file directly: [Get the latest version of BitBar](https://github.com/matryer/bitbar/releases). Then copy it to your Applications folder.

### Installation

1: Clone the repository

```sh
git clone https://github.com/longpdo/bitbar-plugins-custom.git
```

2: Change directory to bitbar-plugins-custom

```sh
cd bitbar-plugins-custom
```

3: Install python requirements

```sh
pip3 install -r requirements.txt
```

<!-- USAGE EXAMPLES -->
## Usage

Run BitBar.app - it will ask you to select a plugins folder, choose the `bitbar-plugins-custom/plugins` folder

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [BitBar](https://github.com/matryer/bitbar)
* [BitBar Plugins](https://github.com/matryer/bitbar-plugins)

<!-- MARKDOWN LINKS & IMAGES -->
[product-screenshot]: images/screenshot.png
[calendarlite-screenshot]: images/CalendarLite.png
[social-media-stats-screenshot]: images/social_media_stats.gif
[yahoo-weather-screenshot]: images/yahoo-weather.png
