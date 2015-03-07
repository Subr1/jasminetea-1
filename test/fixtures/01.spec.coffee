describe __dirname,->
  if process.env.JASMINETEA_MODE is 'SERVER'
    it "Found #{__filename}",->
      console.log "I'am SERVER"

  if process.env.JASMINETEA_MODE is 'CLIENT'
    console.log "I'am CLIENT"

    browser.ignoreSynchronization= on# To be used only in not angular

    it "Found #{__filename}",->
      browser.get '/'
      expect(browser.getTitle()).toEqual 'Welcome to underground...'
