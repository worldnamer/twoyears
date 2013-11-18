#TwoYears

TwoYears is a toy project I've created to introspect on my latest job, which has just come to a close. It's a web-app, but it is intended to be single-user, and as such has no authentication or provision for uploading new information. It's mostly a way for me to visualize commit history.

TwoYears is written in Rails 3, with Angular as a front-end technology. I'm using Rickshaw as a wrapper around D3 for visualization. This may change.

If you want to see it in action, feel free to clone the project and run

```
rake db:drop db:create db:migrate db:seed db:test:prepare
```

and then fire up Rails

```
rails server
```

and then use a browser to look at http://localhost:3000/#/

Oh, and one more thing. The commit history in the seed file has been lightly encrypted to keep the focus on the visualization and architecture aspects of the tool. Please don't mess with that.

-John

##Next Steps
 - Add repository to Commit so that I can add commits from my other projects from this time
 - Create a GitHub commit hook to pull in new commits
 - Create week/month views for charts so that larger trends can be seen more clearly
 - Add correspondences chart so I can see what tags are likely to be paired with other tags
