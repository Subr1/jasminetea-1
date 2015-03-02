describe __filename,->
  it '',(done)->
    setTimeout ->
      expect(true).toEqual(true)
      done()
    ,2