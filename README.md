crystalline
===========

[![Built with
Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?style=flat-square)](https://crystal-lang.org/)
[![Build
Status](https://travis-ci.org/jtomschroeder/crystalline.svg)](https://travis-ci.org/jtomschroeder/crystalline)
[![MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://en.wikipedia.org/wiki/MIT_License)

Collection of Containers and Algorithms.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crystalline:
    github: jtomschroeder/crystalline
```

## Usage

* [Algorithms](#algorithms)
  - [KMP Search](#kmp-search)
  - [Search](#search)
* [Containers](#containers)
  - [Heap](#heap)
  - [KD Tree](#kd-tree)
  - [Priority Queue](#priority-queue)
  - [Queue](#queue)
  - [RB Tree Map]()
  - [Splay Tree Map]()
  - [Stack]()
  - [Suffix Array]()
  - [Trie]()
* [Graph]()

### Algorithms

```crystal
require "crystalline/algorithms/*"
```

#### KMP Search

```crystal
Crystalline::Algorithms::Search.kmp_search("the quick brown fox jumped over the lazy dog.", dog)
# =>

include Crystalline::Algorithms::Search

kmp_search("abcddcba", "cdd") # =>

```

#### Search

```crystal
array = [0,1,2,3,4,5,6,7,8,9]
Crystalline::Algorithms::Search.binary_search(array, 5)
# => 5

Crystalline::Algorithms::Search.binary_search(array, 10)
# => nil
```

### Containers

```crystal
require "crystalline/containers/*"
```

### Graph


## Contributing

1. Fork it (<https://github.com/jtomschroeder/crystalline/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
