## No wrapping line of code with pretext example

How do you put a tab space in markdown?

```
A single TAB before text with a blank line before and after it  make a non wrapping code line code box
```

* Type ensp to add 2 spaces.
* Type emsp to add 4 spaces.
  * Type ensp to add 2 spaces.
  * Type emsp to add 4 spaces.
    * You can use non-breaking space ( nbsp ) 4 times to insert a tab.

<br>

## Tripple layer drill down example, indented

<details>
<summary>Heading1</summary>

some text
+ <details>
    <summary>Heading1.1</summary>

    some more text
    + <details>
        <summary>Heading1.1.1</summary>
        even more text
      </details>
   </details>
</details>

<BR>

## Tripple layer drill down, no indent

<details>
<summary>Heading1</summary>
some text
<details>
<summary>Heading1.1</summary>
some more text
<details>
<summary>Heading1.1.1</summary>
 even more text
</details>
</details>
</details>

<BR>

## Colored Box with code inside

<details>
<summary><mark><font color=darkred>Android Node Tree</font></mark>
</summary>
<p>

```xml

 <?xml version='1.0' encoding='UTF-8' standalone='yes' ?>

```

</p>
</details>

<BR>

----

## Mix & Match

<details markdown="1">
  <summary markdown="span">This is the summary text, click me to expand</summary>

  This is the detailed text.

  We can still use markdown, but we need to take the additional step of using the `parse_block_html` option as described in the [Mix HTML + Markdown Markup section](#mix-html--markdown-markup).

  You can learn more about expected usage of this approach in the [GitLab UI docs](https://gitlab-org.gitlab.io/gitlab-ui/?path=/story/base-collapse--default) though the solution we use above is specific to usage in markdown.
</details>

<details markdown="1">
<summary markdown="span">First level collapsible item</summary>

**Lorem ipsum dolor sit amet...**
<details markdown="1">
<summary markdown="span">Second level collapsible item</summary>

*Sed ut perspiciatis unde omnis iste natus...*
</details>
</details>

<BR>

## Simple Disclosure statement example
<details>
  <summary>System Requirements</summary>
  <p>Requires a computer running an operating system. The computer
  must have some memory and ideally some kind of long-term storage.
  An input device as well as some form of output device is
  recommended.</p>
</details>

<BR>

## Creating an open disclosure box

<details open>
  <summary>System Requirements</summary>
  <p>Requires a computer running an operating system. The computer
  must have some memory and ideally some kind of long-term storage.
  An input device as well as some form of output device is
  recommended.</p>
</details>

<BR>


## Toggle Example

<details><summary>Toggle me!</summary>Peek a boo!</details></details>

<br>

## Toggle Example


## Spacing & Indent example example

Remember that blank lines are needed before/after a section of markdown that is within an html tag, otherwise the markdown won't work

<p style="margin-left:10%; margin-right:10%;">This is the text that I want to indent. I want to create a margin on both sides so that it doesn't go the full width of the page. Don't ask me why I want to do this. I just do!</p>

 <p style="margin-left:10%; margin-right:10%; color:red">This is the text that I want to indent. I want to create a margin on both sides so that it doesn't go the full width of the page. Don't ask me why I want to do this. I just do!</p>

 <p style="margin-left:200px; margin-right:50px;">This is the text that I want to indent. I want to create a margin on both sides so that it doesn't go the full width of the page. Don't ask me why I want to do this. I just do!</p>

<BR>

## Blockquote Examples

> This is the first level of quoting.
>
> > This is nested blockquote.
>
> Back to the first level.

<BR>

> ## This is a header example like in an SOP.
>
> 1.   This is the first list item.
> 2.   This is the second list item.
>
> Here's some example code:
>
>     return shell_exec("echo $input | $markdown_script");

<BR>

> This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,
consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.

> Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse
id sem consectetuer libero luctus adipiscing.

<BR>

## List Examples

*   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
*   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.

    <BR>

1.  This is a list item with two paragraphs. Lorem ipsum dolor
    sit amet, consectetuer adipiscing elit. Aliquam hendrerit
    mi posuere lectus.

    Vestibulum enim wisi, viverra nec, fringilla in, laoreet
    vitae, risus. Donec sit amet nisl. Aliquam semper ipsum
    sit amet velit.

2.  Suspendisse id sem consectetuer libero luctus adipiscing.

<BR>

*   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.

    <BR>

*   A list item with a code block:

        <code goes here>

<BR><p>Here is an example of AppleScript:</p>

<pre><code>tell application "Foo"
    beep
end tell
</code></pre>

<BR>

## Links

This is [an example](http://example.com/ "Title") inline link.

[This link](http://example.net/) has no title attribute.

If you're referring to a local resource on the same server, you can use relative paths:

See my [About](/about/) page for details.
Reference-style links use a second set of square brackets, inside which you place a label of your choosing to identify the link:

This is [an example][isd] reference-style link.
You can optionally use a space to separate the sets of brackets:

This is [an example] [isd] reference-style link.
Then, anywhere in the document, you define your link label like this, on a line by itself:

[isd]: http://examples.com/  "Optional Title Here"

<BR>

Here's an example of reference links in action:

I get 10 times more traffic from [Google][] than from
[Yahoo][] or [MSN][].

  [google]: http://google.com/        "Google"
  [yahoo]:  http://search.yahoo.com/  "Yahoo Search"
  [msn]:    http://search.msn.com/    "MSN Search"

<BR>

# Code
To indicate a span of code, wrap it with backtick quotes (`). Unlike a pre-formatted code block, a code span indicates code within a normal paragraph. For example:

Use the `printf()` function.

o include a literal backtick character within a code span, you can use multiple backticks as the opening and closing delimiters:

``There is a literal backtick (`) here.``
which will produce this:

<p><code>There is a literal backtick (`) here.</code></p>
The backtick delimiters surrounding a code span may include spaces -- one after the opening, one before the closing. This allows you to place literal backtick characters at the beginning or end of a code span:

A single backtick in a code span: `` ` ``

A backtick-delimited string in a code span: `` `foo` ``
will produce:

<p>A single backtick in a code span: <code>`</code></p>

<p>A backtick-delimited string in a code span: <code>`foo`</code></p>
With a code span, ampersands and angle brackets are encoded as HTML entities automatically, which makes it easy to include example HTML tags. Markdown will turn this:

Please don't use any `<blink>` tags.
into:

<p>Please don't use any <code>&lt;blink&gt;</code> tags.</p>
You can write this:

`&#8212;` is the decimal-encoded equivalent of `&mdash;`.
to produce:

<p><code>&amp;#8212;</code> is the decimal-encoded
equivalent of <code>&amp;mdash;</code>.</p>

<BR>

## Automatic Links

Markdown supports a shortcut style for creating "automatic" links for URLs and email addresses: simply surround the URL or email address with angle brackets. What this means is that if you want to show the actual text of a URL or email address, and also have it be a clickable link, you can do this:

<http://example.com/>

Markdown will turn this into:

<a href="http://example.com/">http://example.com/</a>

Automatic links for email addresses work similarly, except that Markdown will also perform a bit of randomized decimal and hex entity-encoding to help obscure your address from address-harvesting spambots. For example, Markdown will turn this:

<address@example.com>

<BR>

<figure class="video_container">

<iframe src="https://docs.google.com/spreadsheets/d/1jAnvYpRmNu8BISIrkYGTLolOTmlCoKLbuHVWzCXJSY4/pubhtml?widget=true&amp;headers=false"></iframe>

</figure>

Output:


## Google Presentation Ebedded

<figure class="video_container">
<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vS_iuMXnp61wlo4amm5nvHr4Ir8VUzisJSBsr7YEL7fKWAiT-9bmehyngtb9TYaFEsFnRokCyIXwsvY/embed?start=false&loop=false&delayms=3000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>
</figure>
Output:

<BR>
