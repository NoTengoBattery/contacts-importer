# Contacts Importer

This program uses background jobs and JSONB objects to extrac contacts from a CSV file and store them in a database. The contacts are associated to a user as well as the processed CSV file.

I tried to make this program in less than 24 hours but it's too much work. Currently, this project is missing:
  - UX: List all contacts uploaded by the user
  - UX: List all contact list and CSV uploaded by the user
  - UX: Links to change the language (yes, it's multilingual)
  - Backend: validations for the contact model
  - Backend: more test coverage

What it does and have:
  - Supports multiple languages (English and Spanish)
  - Parses the file in a background job
  - Some A-UAT testing (sing in/up)
  - Support changing to all statuses (as per the spec and more)
  - Parses and stores the contacts to the database (Contact.all)
  - Deployed to Heroku
  - Resque with Redis as backend
  - Caching of partials and expensive computations
  - It has a Bucketeer S3 storage backend and the file can be downloaded
  - Allows and supports user mappings in the GUI
  - A cool CI and a (almost) perfect use of Git Flow
    - Yeah, this ones I am commiting direcly to develop. I know is wrong.

If I had enough time, this would be the plan:
  - Create a model for the JSONB "details" column and implement the validations
  - Populate the indexes of ContactLists and Contacts
  - Add more A-UAT and unit testing
  - Show the features that are implemented but doesn't work on the front-end yet
  - Spot n+1 queries with Bullet (included in RSpec and in the browser)
  - Cache more partials and expensive computations
  - Implement the scoped uniqueness check (that prevents a user from having 2 contacts with the same email)
  - Add seeds for a demo user and a demo CSV file

## Why?

I tend to overthink and I always want to keep things sharp and snappy. I plan way ahead and that's where I invest most of the time. I already have a plan and know exactly what to do, what's missing and how to do it. Is just a matter that thinking takes some time and sadly more time than the goal.

This mindset intereferes greatly with short deadlines. If I had enough time, say, 3 days, this project would probably be top-tier and outplay most implementations. And is not surprise. The time that I take to make the plan is not "wasted" in the end. Is well invested time. It's more about the architecture and design than about writing the code.

I think that this project, and at this point, is enough to showcase my ability. I will finish it, anyway. If you look carefully enough, you will easily notice it. Are you not convinced? Well, that's cool. Let's have a thorough talk about this. Challenge me as much as you want.



I made costly architectural decisions such as using Tailwind (not a good time saver like Bootrstrap), using a background job from the beginning, using S3 from the beginning, deploying to Heroku from the beginning and using JSONB instead of relational column. That last one is a powerful decision. See, is the best of the relational world, like the through table ContactList (User <=<> Contact List <>=> Contacts) and the best of the document world. This implementation is future-proof. Just think about that.

## Installing and running locally

### System dependencies

A Linux machine is preferred. Install the following dependencies (the process varies depending on your local setup):
| Dependency                | Version                |
| ------------------------- | ---------------------- |
| GIT VCS                   | **any modern version** |
| Ruby                      | 3.0.2+                 |
| Node.js                   | 16.4+                  |
| PostgreSQL                | 12+                    |
| Redis                     | 6+                     |
| Foreman                   | 0.87+                  |
| Google Chrome or Chromium | **any modern version** |
| Firefox                   | **any modern version** |

### Instructions

1. Clone this repository locally, for example `git clone https://github.com/NoTengoBattery/contacts-importer`
2. Change to the project's root directory, for example `cd contacts-importer`
3. Install the Ruby dependencies with `bundle install`
4. Install the Node.js dependencies with `yarn install`
5. Roll a new set of credentials with `rm config/credentials.yml.enc; bundle exec rails credentials:edit`
   - May need to set-up a proper text editor for this command to work. Try `export EDITOR=nano`
   - To deploy to staging and review apps, add HTTP login details in this file. Not needed locally.
6. Prepare the database with `bundle exec rails db:prepare`
   - May need to setup the PostgreSQL roles beforehand
7. Run the server using `foreman start` and browse to it's URL
8. Execute the test suite using `bundle exec rspec`
   - The feature test may fail if Chrome is not installed. Run this command if you have Firefox: `USING_BROWSER=firefox bundle exec rspec`
   - The feature test may fail in headless configs. Run this command if you have headless config: `CI=true bundle exec rspec`

## Live demo

As always, you can find a live demo in [Heroku](https://thawing-cove-15494.herokuapp.com/)
> Using free dynos, so, don't expect excellent performance

## Authors

👤 **Oever González**

-   GitHub: [@NoTengoBattery](https://github.com/NoTengoBattery/)
-   Twitter: [@NoTengoBattery](https://twitter.com/NoTengoBattery/)
-   LinkedIn: [Oever González](https://linkedin.com/in/NoTengoBattery/)

## Acknowledgments

-   JetBrains for their amazing [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono#about) monospace font family
-   NoTengoBattery for my amazing and time-saving [Rails Template](https://github.com/NoTengoBattery/rails6-webpacker/)

## 📝 License

Redistribution and public exposure is prohibited. Disclosure is prohibited except for the contributors. All rights reserved. Oever González (c) 2021.
