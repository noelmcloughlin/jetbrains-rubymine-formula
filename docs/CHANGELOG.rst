
Changelog
=========

`1.0.2 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/compare/v1.0.1...v1.0.2>`_ (2020-07-28)
--------------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **cmd.run:** wrap url in quotes (zsh) (\ `1641a52 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/1641a5291586c4d694facec61553a8aa37f57045>`_\ )
* **macos:** do not create shortcut file (\ `7d637e9 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/7d637e93bd9dc4cb4ace917a41b1c556c8a0b0ac>`_\ )
* **macos:** do not create shortcut file (\ `33451f0 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/33451f021b3895fd0f44fe7e5e12471acac771dc>`_\ )

Code Refactoring
^^^^^^^^^^^^^^^^


* **jetbrains:** align all jetbrains formulas (\ `682e972 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/682e97269fe3e288489751fb226168f26e15b119>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** use ``saltimages`` Docker Hub where available [skip ci] (\ `8c0405d <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/8c0405d984979a653dc5fa85ccd559844f99ba37>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** minor update (\ `8fc972b <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/8fc972bb3a1a3147f82628ec1be93122cabbab33>`_\ )

Styles
^^^^^^


* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] (\ `94c8e84 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/94c8e844b0d176681cde05431422d4238f0d1d57>`_\ )

`1.0.1 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/compare/v1.0.0...v1.0.1>`_ (2020-06-15)
--------------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **edition:** better edition jinja code (\ `ff739a5 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/ff739a56ede34a150b443561dc9b0ed6eea7b81b>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** add new platforms [skip ci] (\ `23c22e3 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/23c22e34fd24b658ff039bf49267943d7392f03d>`_\ )
* **kitchen+travis:** adjust matrix to add ``3000.3`` [skip ci] (\ `41f92cd <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/41f92cd1e751811ce700339f82ab58a5ce7e1d56>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `fb19162 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/fb191620f024c8f5187e2355c8a3789eb2ff7e6d>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** improve formatting (\ `4967150 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/49671503f6581fb62c1caca04b2b56b6bcc06db8>`_\ )

`1.0.0 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/compare/v0.1.2...v1.0.0>`_ (2020-05-12)
--------------------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **formula:** align to template formula; add ci (\ `0d7de6c <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/0d7de6c6de3696305b3a2968d6fddbe91191a93d>`_\ )
* **formula:** align to template formula; add ci (\ `21b1306 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/21b13061ffe0ca8d602f7b8782e64004e8a7e56f>`_\ )
* **semantic-release:** standardise for this formula (\ `f7ecc20 <https://github.com/saltstack-formulas/jetbrains-rubymine-formula/commit/f7ecc2012e55f5cbc1dfc3a6a082d2d43f420638>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **formula:** Major refactor of formula to bring it in alignment with the
  template-formula. As with all substantial changes, please ensure your
  existing configurations work in the ways you expect from this formula.
