const fs = require('fs')
const mkdirp = require('mkdirp')
const path = require('path')
const merge = require('deepmerge')
const transforms = require('./transforms')
const regexUtils = require('./utils/regex')
const pluginSortOrder = require('./utils/sortOrder')
const updateContents = require('./updateContents')
const cwd = process.cwd()

module.exports = async function processFile(filePath, config) {
  let content
  try {
    content = fs.readFileSync(filePath, 'utf8')
  } catch (e) {
    console.log(`FILE NOT FOUND ${filePath}`)
    throw e
  }
  /**
   * ### Configuration Options
   */
  const defaultConfig = {
    /**
     * - `transforms` - *object* - (optional) Custom commands to transform block contents, see transforms & custom transforms sections below.
     * @type {Object}
     */
    transforms: transforms,
    /**
     * - `outputDir` - *string* - (optional) Change output path of new content. Default behavior is replacing the original file
     * @type {string}
     */
    outputDir: path.dirname(filePath),
    /**
     * - `matchWord` - *string* - (optional) Comment pattern to look for & replace inner contents. Default `AUTO-GENERATED-CONTENT`
     * @type {string}
     * @default [AUTO-GENERATED-CONTENT]
     */
    matchWord: 'AUTO-GENERATED-CONTENT',
    /**
     * - `DEBUG` - *Boolean* - (optional) set debug flag to `true` to inspect the process
     * @type {boolean}
     */
    DEBUG: false,
  }

  const userConfig = (config && typeof config === 'object') ? config : {}
  const mergedConfig = merge(defaultConfig, userConfig)

  const registeredTransforms = Object.keys(mergedConfig.transforms)
  // Set originalPath constant
  mergedConfig.originalPath = filePath
  // contents of original MD file
  mergedConfig.originalContent = content
  // set default outputContents for first pass for single commands
  mergedConfig.outputContent = content

  const regex = regexUtils.matchCommentBlock(mergedConfig.matchWord)
  // console.log(regex)
  const match = content.match(regex)
  const transformsFound = []

  if (match) {
    let commentMatches
    let matchIndex = 0
    while ((commentMatches = regex.exec(content)) !== null) {
      if (commentMatches.index === regex.lastIndex) {
        regex.lastIndex++ // This is necessary to avoid infinite loops
      }

      // console.log('commentMatches', commentMatches)
      // const command = `Transform ${commentMatches[2]}`
      // console.log(command)
      transformsFound.push({
        spaces: commentMatches[1], // Preserve indentation
        transform: commentMatches[2],
        match: match[matchIndex]
      })
      // wait
      matchIndex++
    }

    // console.log('registeredTransforms', registeredTransforms)

    const transformsToRun = pluginSortOrder(registeredTransforms, transformsFound)
    if (mergedConfig.DEBUG) {
      console.log('↓ transformsToRun')
      console.log(transformsToRun)
    }

    const fileName = path.basename(filePath)
    const outputFilePath = path.join(mergedConfig.outputDir, fileName)

    // create folder path if doesnt exist
    mkdirp.sync(mergedConfig.outputDir)

    // run sort
    let transformMsg = ''
    for (const element of transformsToRun) {
      // console.log('element', element)
      transformMsg += `  ⁕ ${element.transform} \n`
      // console.log('order', element.transform)
      const newContent = await updateContents(element.match, mergedConfig)
      const firstLineIndentation = element.spaces
      const contentWithIndentation = newContent.split('\n').join(`\n` + element.spaces)
      const preserveTabs = `${firstLineIndentation}${contentWithIndentation}`

      content = content.replace(element.match, preserveTabs)
      mergedConfig.outputContent = content
    }

    let notFoundNotice
    if (!transformMsg) {
      // console.log('config', config)
      const notFound = transformsFound.map((x) => {
        return `"${x.transform}"`
      })
      notFoundNotice = notFound
    }

    // console.log('transformMsg', transformMsg)

    const msg = outputFilePath.replace(cwd, '')

    if (transformMsg) {
      console.log(`✔ ${msg} Updated`)
      // update file contents
      fs.writeFileSync(outputFilePath, content)
      console.log(` Transforms run`)
      console.log(transformMsg)
    }

    if (notFoundNotice) {
      const word = notFoundNotice.length > 1 ? 'transforms' : 'transform'
      console.log(`ℹ Notice:`)
      console.log(`  Missing ${word} ${notFoundNotice.join(',')} in ${msg}`)
      console.log()
    }


    // set return values
    mergedConfig.outputFilePath = outputFilePath
    mergedConfig.outputContent = content

    return mergedConfig
  }

  if (mergedConfig.DEBUG) {
    console.log(`↓ ${filePath}`)
    console.log(`[No match] <!-- ${mergedConfig.matchWord} --> comment found`)
  }

  // no match return original contents
  return mergedConfig
}
