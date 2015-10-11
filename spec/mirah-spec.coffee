describe "Mirah grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-mirah")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.mirah")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.mirah"

  it "tokenizes self", ->
    {tokens} = grammar.tokenizeLine('self')
    expect(tokens[0]).toEqual value: 'self', scopes: ['source.mirah', 'variable.language.self.mirah']

  it "tokenizes special functions", ->
    {tokens} = grammar.tokenizeLine('import "."')
    expect(tokens[0]).toEqual value: 'import', scopes: ['source.mirah', 'meta.import.mirah', 'keyword.other.special-method.mirah']

  it "tokenizes symbols", ->
    {tokens} = grammar.tokenizeLine(':test')
    expect(tokens[0]).toEqual value: ':', scopes: ['source.mirah', 'constant.other.symbol.mirah', 'punctuation.definition.constant.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'constant.other.symbol.mirah']

    {tokens} = grammar.tokenizeLine(':$symbol')
    expect(tokens[0]).toEqual value: ':', scopes: ['source.mirah', 'constant.other.symbol.mirah', 'punctuation.definition.constant.mirah']
    expect(tokens[1]).toEqual value: '$symbol', scopes: ['source.mirah', 'constant.other.symbol.mirah']

    {tokens} = grammar.tokenizeLine(':<=>')
    expect(tokens[0]).toEqual value: ':', scopes: ['source.mirah', 'constant.other.symbol.mirah', 'punctuation.definition.constant.mirah']
    expect(tokens[1]).toEqual value: '<=>', scopes: ['source.mirah', 'constant.other.symbol.mirah']

  it "tokenizes symbol as hash key (1.9 syntax)", ->
    {tokens} = grammar.tokenizeLine('foo: 1')
    expect(tokens[0]).toEqual value: 'foo', scopes: ['source.mirah', 'constant.other.symbol.hashkey.mirah']
    expect(tokens[1]).toEqual value: ':', scopes: ['source.mirah', 'constant.other.symbol.hashkey.mirah', 'punctuation.definition.constant.hashkey.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']

  it "tokenizes symbol as hash key (1.8 syntax)", ->
    {tokens} = grammar.tokenizeLine(':foo => 1')
    expect(tokens[0]).toEqual value: ':', scopes: ['source.mirah', 'constant.other.symbol.hashkey.mirah', 'punctuation.definition.constant.mirah']
    expect(tokens[1]).toEqual value: 'foo', scopes: ['source.mirah', 'constant.other.symbol.hashkey.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: '=>', scopes: ['source.mirah', 'punctuation.separator.key-value']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[5]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']

  it "tokenizes :: separators", ->
    {tokens} = grammar.tokenizeLine('File::read "test"')
    expect(tokens[0]).toEqual value: 'File', scopes: ['source.mirah', 'support.class.mirah']
    expect(tokens[1]).toEqual value: '::', scopes: ['source.mirah', 'punctuation.separator.method.mirah']
    expect(tokens[2]).toEqual value: 'read ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('File:: read "test"')
    expect(tokens[0]).toEqual value: 'File', scopes: ['source.mirah', 'variable.other.constant.mirah']
    expect(tokens[1]).toEqual value: '::', scopes: ['source.mirah', 'punctuation.separator.method.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: 'read ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('RbConfig::CONFIG')
    expect(tokens[0]).toEqual value: 'RbConfig', scopes: ['source.mirah', 'support.class.mirah']
    expect(tokens[1]).toEqual value: '::', scopes: ['source.mirah', 'punctuation.separator.namespace.mirah']
    expect(tokens[2]).toEqual value: 'CONFIG', scopes: ['source.mirah', 'variable.other.constant.mirah']

    {tokens} = grammar.tokenizeLine('RbConfig:: CONFIG')
    expect(tokens[0]).toEqual value: 'RbConfig', scopes: ['source.mirah', 'variable.other.constant.mirah']
    expect(tokens[1]).toEqual value: '::', scopes: ['source.mirah', 'punctuation.separator.namespace.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: 'CONFIG', scopes: ['source.mirah', 'variable.other.constant.mirah']

  it "tokenizes . separator", ->
    {tokens} = grammar.tokenizeLine('File.read "test"')
    expect(tokens[0]).toEqual value: 'File', scopes: ['source.mirah', 'support.class.mirah']
    expect(tokens[1]).toEqual value: '.', scopes: ['source.mirah', 'punctuation.separator.method.mirah']
    expect(tokens[2]).toEqual value: 'read ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('File. read "test"')
    expect(tokens[0]).toEqual value: 'File', scopes: ['source.mirah', 'variable.other.constant.mirah']
    expect(tokens[1]).toEqual value: '.', scopes: ['source.mirah', 'punctuation.separator.method.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: 'read ', scopes: ['source.mirah']

  it "tokenizes %{} style strings", ->
    {tokens} = grammar.tokenizeLine('%{te{s}t}')

    expect(tokens[0]).toEqual value: '%{', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.begin.mirah']
    expect(tokens[1]).toEqual value: 'te', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[2]).toEqual value: '{', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[3]).toEqual value: 's', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[4]).toEqual value: '}', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[5]).toEqual value: 't', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[6]).toEqual value: '}', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.end.mirah']

  it "tokenizes %() style strings", ->
    {tokens} = grammar.tokenizeLine('%(te(s)t)')

    expect(tokens[0]).toEqual value: '%(', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.begin.mirah']
    expect(tokens[1]).toEqual value: 'te', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[2]).toEqual value: '(', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[3]).toEqual value: 's', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[4]).toEqual value: ')', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[5]).toEqual value: 't', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[6]).toEqual value: ')', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.end.mirah']

  it "tokenizes %[] style strings", ->
    {tokens} = grammar.tokenizeLine('%[te[s]t]')

    expect(tokens[0]).toEqual value: '%[', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.begin.mirah']
    expect(tokens[1]).toEqual value: 'te', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[2]).toEqual value: '[', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[3]).toEqual value: 's', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[5]).toEqual value: 't', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[6]).toEqual value: ']', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.end.mirah']

  it "tokenizes %<> style strings", ->
    {tokens} = grammar.tokenizeLine('%<te<s>t>')

    expect(tokens[0]).toEqual value: '%<', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.begin.mirah']
    expect(tokens[1]).toEqual value: 'te', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[2]).toEqual value: '<', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[3]).toEqual value: 's', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[4]).toEqual value: '>', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.section.scope.mirah']
    expect(tokens[5]).toEqual value: 't', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah']
    expect(tokens[6]).toEqual value: '>', scopes: ['source.mirah', 'string.quoted.other.interpolated.mirah', 'punctuation.definition.string.end.mirah']

  it "tokenizes regular expressions", ->
    {tokens} = grammar.tokenizeLine('/test/')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('/{w}/')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: '{w}', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('a_method /test/')

    expect(tokens[0]).toEqual value: 'a_method ', scopes: ['source.mirah']
    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[3]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('a_method(/test/)')

    expect(tokens[0]).toEqual value: 'a_method', scopes: ['source.mirah']
    expect(tokens[1]).toEqual value: '(', scopes: ['source.mirah', 'punctuation.section.function.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[4]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[5]).toEqual value: ')', scopes: ['source.mirah', 'punctuation.section.function.mirah']

    {tokens} = grammar.tokenizeLine('/test/.match("test")')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: '.', scopes: ['source.mirah', 'punctuation.separator.method.mirah']

    {tokens} = grammar.tokenizeLine('foo(4 / 2).split(/c/)')

    expect(tokens[0]).toEqual value: 'foo', scopes: ['source.mirah']
    expect(tokens[1]).toEqual value: '(', scopes: ['source.mirah', 'punctuation.section.function.mirah']
    expect(tokens[2]).toEqual value: '4', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[7]).toEqual value: ')', scopes: ['source.mirah', 'punctuation.section.function.mirah']
    expect(tokens[8]).toEqual value: '.', scopes: ['source.mirah', 'punctuation.separator.method.mirah']
    expect(tokens[9]).toEqual value: 'split', scopes: ['source.mirah']
    expect(tokens[10]).toEqual value: '(', scopes: ['source.mirah', 'punctuation.section.function.mirah']
    expect(tokens[11]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[12]).toEqual value: 'c', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[13]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[14]).toEqual value: ')', scopes: ['source.mirah', 'punctuation.section.function.mirah']

    {tokens} = grammar.tokenizeLine('[/test/,3]')

    expect(tokens[0]).toEqual value: '[', scopes: ['source.mirah', 'punctuation.section.array.begin.mirah']
    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[3]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[4]).toEqual value: ',', scopes: ['source.mirah', 'punctuation.separator.object.mirah']

    {tokens} = grammar.tokenizeLine('[/test/]')

    expect(tokens[0]).toEqual value: '[', scopes: ['source.mirah', 'punctuation.section.array.begin.mirah']
    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[3]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('/test/ && 4')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('/test/ || 4')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('/test/ ? 4 : 3')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('/test/ : foo')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('{a: /test/}')

    expect(tokens[4]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[5]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[6]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('if "test" =~ /test/ then 4 end')

    expect(tokens[8]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[9]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[10]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[11]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[12]).toEqual value: 'then', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('if "test" =~ /test/; 4 end')

    expect(tokens[8]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[9]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[10]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[11]).toEqual value: ';', scopes: ['source.mirah', 'punctuation.separator.statement.mirah']

    {tokens} = grammar.tokenizeLine('/test/ =~ "test"')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '=~', scopes: ['source.mirah', 'keyword.operator.comparison.mirah']

    {tokens} = grammar.tokenizeLine('/test/ !~ "test"')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '!~', scopes: ['source.mirah', 'keyword.operator.comparison.mirah']

    {tokens} = grammar.tokenizeLine('/test/ != "test"')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '!=', scopes: ['source.mirah', 'keyword.operator.comparison.mirah']

    {tokens} = grammar.tokenizeLine('/test/ == /test/')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '==', scopes: ['source.mirah', 'keyword.operator.comparison.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[7]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[8]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('/test/ === /test/')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '===', scopes: ['source.mirah', 'keyword.operator.comparison.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[7]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[8]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']

    {tokens} = grammar.tokenizeLine('if false then /test/ else 4 end')

    expect(tokens[4]).toEqual value: 'then', scopes: ['source.mirah', 'keyword.control.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[7]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[8]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[9]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[10]).toEqual value: 'else', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('if false then 4 else /test/ end')

    expect(tokens[8]).toEqual value: 'else', scopes: ['source.mirah', 'keyword.control.mirah']
    expect(tokens[9]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[10]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[11]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[12]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[13]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[14]).toEqual value: 'end', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('if true then /test/ elsif false then 4 end')

    expect(tokens[4]).toEqual value: 'then', scopes: ['source.mirah', 'keyword.control.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[7]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[8]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[9]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[10]).toEqual value: 'elsif', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('method /test/ do; end')

    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[3]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[5]).toEqual value: 'do', scopes: ['source.mirah', 'keyword.control.start-block.mirah']

    {tokens} = grammar.tokenizeLine('/test/ if true')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: 'if', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('/test/ unless true')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: 'unless', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('/test/ while true')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: 'while', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('/test/ until true')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: 'until', scopes: ['source.mirah', 'keyword.control.mirah']

    {tokens} = grammar.tokenizeLine('/test/ or return')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: 'or', scopes: ['source.mirah', 'keyword.operator.logical.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: 'return', scopes: ['source.mirah', 'keyword.control.pseudo-method.mirah']

    {tokens} = grammar.tokenizeLine('/test/ and return')

    expect(tokens[0]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[1]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: 'and', scopes: ['source.mirah', 'keyword.operator.logical.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: 'return', scopes: ['source.mirah', 'keyword.control.pseudo-method.mirah']

    {tokens} = grammar.tokenizeLine('{/test/ => 1}')

    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[2]).toEqual value: 'test', scopes: ['source.mirah', 'string.regexp.interpolated.mirah']
    expect(tokens[3]).toEqual value: '/', scopes: ['source.mirah', 'string.regexp.interpolated.mirah', 'punctuation.section.regexp.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[5]).toEqual value: '=>', scopes: ['source.mirah', 'punctuation.separator.key-value']
    expect(tokens[6]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[7]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']

  it "tokenizes the / arithmetic operator", ->
    {tokens} = grammar.tokenizeLine('call/me/maybe')
    expect(tokens[0]).toEqual value: 'call', scopes: ['source.mirah']
    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[2]).toEqual value: 'me', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[4]).toEqual value: 'maybe', scopes: ['source.mirah']

    {tokens} = grammar.tokenizeLine('(1+2)/3/4')
    expect(tokens[0]).toEqual value: '(', scopes: ['source.mirah', 'punctuation.section.function.mirah']
    expect(tokens[1]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[2]).toEqual value: '+', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[3]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[4]).toEqual value: ')', scopes: ['source.mirah', 'punctuation.section.function.mirah']
    expect(tokens[5]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[6]).toEqual value: '3', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[7]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[8]).toEqual value: '4', scopes: ['source.mirah', 'constant.numeric.mirah']

    {tokens} = grammar.tokenizeLine('1 / 2 / 3')
    expect(tokens[0]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[5]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[6]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[7]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[8]).toEqual value: '3', scopes: ['source.mirah', 'constant.numeric.mirah']

    {tokens} = grammar.tokenizeLine('1/ 2 / 3')
    expect(tokens[0]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[5]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[6]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[7]).toEqual value: '3', scopes: ['source.mirah', 'constant.numeric.mirah']

    {tokens} = grammar.tokenizeLine('1 / 2/ 3')
    expect(tokens[0]).toEqual value: '1', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[2]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[4]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[5]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[6]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[7]).toEqual value: '3', scopes: ['source.mirah', 'constant.numeric.mirah']

    {tokens} = grammar.tokenizeLine('x / 2; x /= 2')
    expect(tokens[1]).toEqual value: '/', scopes: ['source.mirah', 'keyword.operator.arithmetic.mirah']
    expect(tokens[2]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[3]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']
    expect(tokens[4]).toEqual value: ';', scopes: ['source.mirah', 'punctuation.separator.statement.mirah']
    expect(tokens[6]).toEqual value: '/=', scopes: ['source.mirah', 'keyword.operator.assignment.augmented.mirah']
    expect(tokens[7]).toEqual value: ' ', scopes: ['source.mirah']
    expect(tokens[8]).toEqual value: '2', scopes: ['source.mirah', 'constant.numeric.mirah']

  it "tokenizes yard documentation comments", ->
    {tokens} = grammar.tokenizeLine('# @private')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'private', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']

    {tokens} = grammar.tokenizeLine('# @deprecated Because I said so')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'deprecated', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']
    expect(tokens[4]).toEqual value: ' Because I said so', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.string.yard.mirah']

    {tokens} = grammar.tokenizeLine('# @raise [Bar] Baz')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'raise', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah']
    expect(tokens[5]).toEqual value: '[', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[6]).toEqual value: 'Bar', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah']
    expect(tokens[7]).toEqual value: ']', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[8]).toEqual value: ' Baz', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.string.yard.mirah']

    {tokens} = grammar.tokenizeLine('# @param foo [Bar] Baz')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'param', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah']
    expect(tokens[5]).toEqual value: 'foo', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.parameter.yard.mirah']
    expect(tokens[6]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah']
    expect(tokens[7]).toEqual value: '[', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[8]).toEqual value: 'Bar', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah']
    expect(tokens[9]).toEqual value: ']', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[10]).toEqual value: ' Baz', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.string.yard.mirah']

    {tokens} = grammar.tokenizeLine('# @param [Bar] Baz')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'param', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah']
    expect(tokens[5]).toEqual value: '[', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[6]).toEqual value: 'Bar', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah']
    expect(tokens[7]).toEqual value: ']', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[8]).toEqual value: ' Baz', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.string.yard.mirah']


    {tokens} = grammar.tokenizeLine('# @return [Array#[](0), Array] comment')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'return', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah']
    expect(tokens[5]).toEqual value: '[', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[6]).toEqual value: 'Array#[](0), Array', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah']
    expect(tokens[7]).toEqual value: ']', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[8]).toEqual value: ' comment', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.string.yard.mirah']

    {tokens} = grammar.tokenizeLine('# @param [Array#[](0), Array] comment')
    expect(tokens[0]).toEqual value: '#', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'punctuation.definition.comment.mirah']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah']
    expect(tokens[2]).toEqual value: '@', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.punctuation.yard.mirah']
    expect(tokens[3]).toEqual value: 'param', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.keyword.yard.mirah']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah']
    expect(tokens[5]).toEqual value: '[', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[6]).toEqual value: 'Array#[](0), Array', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah']
    expect(tokens[7]).toEqual value: ']', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.yard.mirah', 'comment.line.type.yard.mirah', 'comment.line.punctuation.yard.mirah']
    expect(tokens[8]).toEqual value: ' comment', scopes: ['source.mirah', 'comment.line.number-sign.mirah', 'comment.line.string.yard.mirah']
