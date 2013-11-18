angular
  .module('twoyears.services',[])
  .factory('Commit', 
    ($resource) ->
      class Commit
        constructor: () ->

        all: () ->
          $resource('/api/commits.json').query()

        addTag: (commit, tag) ->
          commit.tags.push({text: tag})

          tag_for_uri = encodeURIComponent(tag)
          resource = $resource("/api/commits/#{commit.commit_hash}/tags/#{tag_for_uri}", {}, 
            update:
              method: 'PUT'
          )

          resource.update(
            text: tag
          )

        removeTag: (commit, index) ->
          commit.tags.forEach (tag, i) ->
            if i == index
              removed = commit.tags.splice(i, 1)
              $resource("/api/commits/#{commit.commit_hash}/tags/#{removed[0].text}").delete()
  )
  .factory('Tag', 
    ($resource) ->
      class Tag
        constructor: () ->

        all: () ->
          $resource('/api/tags.json').query()
  );