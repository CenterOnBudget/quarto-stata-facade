# Stata Facade

A Quarto extension that hides the evidence of faking Stata dynamic content with Python code blocks and [Stata cell magic](https://www.stata.com/python/pystata/notebook/Magic%20Commands1.html).

## Installation

To install this extension in your current directory (or into the Quarto project that you're currently working in), use the following command:

```
quarto install extension centeronbudget/stata-facade
```

This will install the extension under the _extensions subdirectory. If you're using version control, you will want to check in this directory.

## Usage

To enable the extension, add stata-facade to the list of filters for your document or project:

```
---
title: My Document
format: html
filters:
  - stata-facade
---
```

All executable Python code blocks which use Stata cell magic will automatically be outputted as Stata code blocks, with appropriate syntax highlighting and stripped of the Stata cell magic command.

## Warning

This extension is under active development. It has not been tested with all output formats or cell output options.
