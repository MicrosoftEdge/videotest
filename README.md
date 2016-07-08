# Video streaming battery rundown test methodology 

Brandon Heenan
Program Manager, Microsoft Edge

## Summary

We measured the time it took four identical Surface Book laptops to run fully through their batteries while streaming video. The results were recorded with a camera and a [time lapse](https://www.youtube.com/watch?v=rjrxOOfi54k) was made available publicly.

The results showed that Microsoft Edge (7:22:07) lasted: 
* 70% longer than Google Chrome (4:19:50) 
* 43% longer than Mozilla Firefox (5:09:30) 
* 17% longer than Opera (6:18:33)

## Methodology

### Computer setup

The test was performed on four Surface Books (256GB disk, Core i5, 8GB RAM, integrated graphics) running Windows 10 (10586.318 th2_release). These computers were configured to the following settings, to increase consistency between measures and reduce tasks that may start during the measurement and interfere with the results, while still representing a realistic user setup: 

* Display brightness was set to 75% 
* Location was disabled
* Devices were connected to a wireless network
* Defender cache was completely built
* Defragmentation was temporarily disabled
* Ambient light sensor was temporarily disabled
* All queued Ngen complication jobs were completed
* Windows Update was temporarily disabled
* “New network found” prompts were disabled
* Windows Error Reporting was temporarily disabled
* Queued idle tasks were forced to complete prior to the test
* Windows Defender was running normally and up to date
* Devices were fully changed before being physically unplugged and running on battery for the test
* Volume was turned to 25%
* Battery Saver was off, but enabled automatically when the battery reached 20%. Device was set to lower screen brightness when Windows battery saver started.
* BitLocker was disabled 

## Browsers
The specific versions of the browsers tested were: 

| Browser | Version |
| ------- | ------- |
| Edge | Microsoft Edge 25.10586.0.0, Microsoft EdgeHTML 13.10586, “Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586” |
| Chrome | Google Chrome 51.0.2704.63 m (64 bit), “Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.63 Safari/537.36” |
| Firefox | Mozilla Firefox 46.0.1, Mozilla83 – 1.0, “Mozilla/5.0 (Windows NT 10.0; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0” |
| Opera | Opera 38.0 38.0.2220.29, “Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.63 Safari/537.36 OPR/38.0.2220.29”, Power saver enabled |

## Pre-Test

While plugged in, each respective browser was navigated to Netflix.com and logged into the same account. The show **“Nature: Animal Misfits”** was queued and paused immediately on each browser. Each computer was verified to have brightness set to 75% (with ambient brightness disabled) and volume to 25%. 

## Test

1. Start recording with camera
2. Unplug the power bar that all four devices are charging from, ensuring they switch to battery at the same time
3. Immediately push play on all devices and start timing
4. When there’s less than 5 min remaining in the show, manually use the seek control to reset all devices to the beginning
5. Repeat until all devices have run out of battery, recording the time for each of them