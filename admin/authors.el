;;; authors.el --- utility for maintaining Emacs's AUTHORS file  -*- lexical-binding: t; -*-

;; Copyright (C) 2000-2024 Free Software Foundation, Inc.

;; Author: Gerd Moellmann <gerd@gnu.org>
;; Maintainer: emacs-devel@gnu.org
;; Keywords: maint
;; Package: emacs

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Use M-x authors RET to create an *Authors* buffer that can used as
;; or merged with Emacs's AUTHORS file.

;;; Code:

(defvar authors-coding-system 'utf-8
  "Coding system used in the AUTHORS file.")

(defconst authors-many-files 20
  "Maximum number of files for which to print individual information.
If an author has modified more files, only the names of the most
frequently modified files are printed and a count of the additional
files.")

(defconst authors-aliases
  '(
    (nil "A\\. N\\. Other")  ; unknown author 2014-12-03, later removed
    (nil "Anticrisis")
    (nil "akater")
    ("Aaron S. Hawley" "Aaron Hawley")
    ("Alan Third" "Alan J Third")
    ("Alexander Gramiak" "Alex Gramiak")
    ("Alexandru Harsanyi" "Alex Harsanyi")
    ("Álvar Jesús Ibeas Martín" "Álvar Ibeas")
    (nil "ambihelical")
    ("Andrea Corallo" "AndreaCorallo")
    ("Andrii Kolomoiets" "andreyk\\.mad@gmail\\.com")
    ("Andrew Csillag" "Drew Csillag")
    ("Andrew G Cohen" "Andrew Cohen")
    ("Anna M. Bigatti" "Anna Bigatti")
    ("Aurélien Aptel" "Aurelien Aptel")
    ("Barry A. Warsaw" "Barry A. Warsaw, Century Computing, Inc."
     "Barry A. Warsaw, ITB" "Barry Warsaw")
    ("Bastien Guerry" "Bastien .*bzg")
    ("Benjamin Carlsson" "glacials" "ben@twos\\.dev")
    ("Benjamin Schwerdtner" "Benjamin\\.Schwerdtner@gmail\\.com" "Ben Schw")
    ("Bill Carpenter" "WJ Carpenter")
    ("Bill Mann" "William F. Mann")
    ("Bill Rozas" "Guillermo J. Rozas")
    ("Billy Zheng" "vil963@gmail\\.com")
    (nil "binjo\\.cn@gmail\\.com")
    (nil "bug-gnu-emacs@gnu\\.org")  ; mistake
    ("Björn Torkelsson" "Bjorn Torkelsson")
    ("Brian Fox" "Brian J. Fox")
    ("Brian P Templeton" "BT Templeton")
    ("Brian Sniffen" "Brian T. Sniffen")
    (nil "brotzeitmacher@gmail\\.com")
    (nil "castor@my-dejanews")
    (nil "chengang31@gmail\\.com")
    (nil "chuntaro")
    ("Clément Pit-Claudel" "Clément Pit--Claudel")
    (nil "Cristian" "crstml@libero\\.it")
    ("Le Trung Dan" "daanturo@gmail\\.com" "Daanturo")
    ("Daniel Freeman" "dannyfreeman")
    ("David Abrahams" "Dave Abrahams")
    ("David J. Biesack" "David Biesack")
    ("David De La Harpe Golden" "David Golden")
    ("David Gillespie" "Dave Gillespie")
    ("David S. Goldberg" "Dave Goldberg")
    ("David Kågedal" "David K..edal")
    ("David M. Koppelman" "David Koppelman")
    ("David M. Smith" "David Smith" "David M Smith")
    ("David O'Toole" "David T. O'Toole")
    ("Daniel Laurens Nicolai" "dalanicolai")
    (nil "deech@deech")
    ("Deepak Goel" "D. Goel")
    ("Earl Hyatt" "Earl" "ej32u@protonmail\\.com")
    ("Ed L. Cashin" "Ed L Cashin")
    ("Edward M. Reingold" "Ed\\(ward\\( M\\)?\\)? Reingold" "Reingold Edward M")
    ("Emilio C. Lopes" "Emilio Lopes")
    ("Eric M. Ludlam" "Eric Ludlam")
    ("Eric S. Raymond" "Eric Raymond")
    ("Etienne Prud’Homme" "Etienne Prud'Homme")
    ("Fabián Ezequiel Gallina" "Fabian Ezequiel Gallina" "Fabi.n E\\. Gallina")
    (nil "felix.*EmacsWiki")
    (nil "felix\\.dick@web\\.de")
    ("Felicián Németh" "Felician Nemeth")
    (nil "foudfou")
    ("Feraidoon Mehri"
     "NightMachinary"
     "rudiwillalwaysloveyou@gmail\\.com" "fifymehry@gmail\\.com")
    ("Francis Litterio" "Fran Litterio")
    ("Francis J. Wright" "Dr Francis J. Wright" "Francis Wright")
    ("François Pinard" "Francois Pinard")
    ("Francesco Potortì" "Francesco Potorti" "Francesco Potorti`")
    ("Frederic Pierresteguy" "Fred Pierresteguy")
    (nil "^FSF")
    (nil "galeo")
    ("Garid Zorigoo" "garid3000" "garidzorigoo@gmail\\.com")
    ("Gerd Möllmann" "Gerd Moellmann")
    (nil "haqle314")
    ("Grégoire Jadi" "Gregoire Jadi")
    ("Hallvard B. Furuseth" "Hallvard B Furuseth" "Hallvard Furuseth")
    (nil "hokomo@airmail\\.cc" "hokomo")
    ("Hrvoje Nikšić" "Hrvoje Niksic")
    ("Ian Dunn" "^Ian D\\>")
    ;; lisp/org/ChangeLog.1 2010-11-11.
    ("Ignacio Casso" "ignacio\\.decasso@imdea\\.org" "ignaciocasso@hotmail\\.com")
    (nil "immerrr")
    (nil "aaa bbb")
    (nil "Code Extracted") ; lisp/newcomment.el's "Author:" header
    (nil "jakanakaevangeli")
    ("J. Alexander Branham" "Alex Branham")
    ("Jaeyoun Chung" "Jae-youn Chung" "Jae-you Chung" "Chung Jae-youn")
    ("Jan Djärv" "Jan D\\>" "Jan Djarv")
    ("Jan Synáček" "Jan Synacek")
    ("João Távora" "João Tãvora")
    ("Jay K. Adams" "Jay Adams")
    ("J.D. Smith" "Jd Smith")
    ("Jérôme Marant" "Jérôme Marant" "Jerome Marant")
    ("Jens Lechtenbörger" "Jens Lechtenboerger")
    ("Jens-Ulrik Holger Petersen" "Jens-Ulrik Petersen")
    ("Jérémie Courrèges-Anglas" "Jeremie Courreges-Anglas")
    ("Jeremy Bertram Maitin-Shepard" "Jeremy Maitin-Shepard")
    ("Jérémy Compostella" "Jeremy Compostella")
    (nil "jgarte@" "jgart")
    (nil "jicksaw@pm\\.me" "jicksaw")
    ("Jimmy Aguilar Mena" "Ergus")
    ("Jindřich Makovička" "Jindrich Makovicka")
    ("Johan Bockgård" "Johan Bockgard")
    ("John F. Carr" "John F Carr")
    ("John J Foerch" "John Foerch")
    ("John W. Eaton" "John Eaton")
    ("Jonathan I. Kamens" "Jonathan Kamens")
    ("Jorgen Schäfer" "Jorgen Schaefer")
    ("Jose A. Ortega Ruiz" "Jose A Ortega Ruiz")
    ("Joseph Arceneaux" "Joe Arceneaux")
    ("Joseph M. Kelsey" "Joe Kelsey")	; FIXME ?
    ("Juan León Lahoz García" "Juan-Leon Lahoz Garcia")
    ("Jürgen Hötzel" "Juergen Hoetzel")
    (nil "k3tu0isui")
    (nil "kby@tilde\\.team")
    ("K. Shane Hartman" "Shane Hartman")
    ("Kai Großjohann" "Kai Grossjohann")
    ("Karl Berry" "K. Berry")
    ("Károly Lőrentey" "Károly Lőrentey" "Lőrentey Károly")
    ("Kazushi Marukawa" "Kazushi (Jam) Marukawa")
    ("Ken Manheimer" "Kenneth Manheimer")
    ("Kenichi Handa" "Ken'ichi Handa" "Kenichi HANDA" "K\\. Handa")
    ("Kevin Greiner" "Kevin J. Greiner")
    ("Kim F. Storm" "Kim Storm")
    ("Kjartan Óli Ágústsson" "Kjartan Oli Agustsson")
    ;; The dash is a kludge, so this contributor is not ignored.
    ("kobarity-" "kobarity@gmail\\.com")
    ("Koen van Greevenbroek" "realcomplex" "koenvg@posteo\\.net")
    ("Kyle Jones" "Kyle E. Jones")
    ("Lars Magne Ingebrigtsen" "Lars Ingebrigtsen")
    ("Laurence Warne" "lWarne" "laurencewarne@gmail\\.com")
    (nil "lensplaysgames@gmail\\.com")
    (nil "lorniu@gmail\\.com")
    (nil "LynX@bk.ru")
    (nil "lu4nx")
    ("Marcus G. Daniels" "Marcus Daniels")
    ("Mark D. Baushke" "Mark D Baushke")
    ("Mark E. Shoulson" "Mark Shoulson")
    ("Marko Kohtala" "Kohtala Marko")
    ("Maxim Nikulin" "Max Nikulin")
    ("Agustín Martín" "Agustin Martin" "Agustín Martín Domingo")
    ("Martin Lorentzon" "Martin Lorentzson")
    ("Matt Swift" "Matthew Swift")
    ("Mattias Engdegård" "Mattias Engdegard")
    (nil "^Madhu")
    (nil "mu@magi.net.ru")
    ("Maxime Edouard Robert Froumentin" "Max Froumentin")
    ("Michael R. Mauger" "Michael Mauger")
    ("Michael D. Ernst" "Michael Ernst")
    ("Michaël Cadilhac" "Michael Cadilhac")
    ("Michael I. Bushnell" "Michael I Bushnell" "Michael I. Bushnell, p/BSG")
    ("Michael R. Cook" "Michael Cook")
    ("Michael Sperber" "Mike Sperber" "Michael Sperber \\[Mr. Preprocessor\\]")
    ("Michalis V" "^mvar")
    ("Miha Rihtaršič" "Miha Rihtarsic" "miha@kamnitnik\\.top" "miha")
    ("Mikio Nakajima" "Nakajima Mikio")
    (nil "montag451@laposte\\.net")
    ("Morgan Smith" "Morgan J\\. Smith")
    ("Mou Tong" "mou\\.tong@outlook\\.com")
    (nil "na@aisrntairetnraoitn")
    (nil "nibon7@163\\.com")
    ("Nelson Jose dos Santos Ferreira" "Nelson Ferreira")
    ("Noah Peart" "noah\\.v\\.peart@gmail\\.com")
    ("Noorul Islam" "Noorul Islam K M")
;;;    ("Tetsurou Okazaki" "OKAZAKI Tetsurou") ; FIXME?
    (nil "odanoburu@")
    (nil "one\\.last\\.kiss@outlook\\.com")
    ("Cao ZhenXiang" "mail@ookami\\.one")
    ("Óscar Fuentes" "Oscar Fuentes")
    (nil "pillule")
    (nil "psyberbits@gmail\\.com")
    ("Paul Eggert" "Paul R\\. Eggert")
    ("Pavel Janík" "Pavel Janík Ml." "Pavel Janik Ml." "Pavel Janik")
    ("Pavel Kobiakov" "Pavel Kobyakov")
    ("Per Abrahamsen" "Per Abhiddenware")
    ("Per Starbäck" "Per Starback")
    ("Peter J. Weisberg" "PJ Weisberg")
    ("Peter S. Galbraith" "Peter S Galbraith" "Peter Galbraith")
    ("Peter Runestig" "Peter 'luna' Runestig")
    ("Philip Kaludercic" "Philip K\\." "Philip K")
    ("Philipp Stephani" "Philipp .*phst@google")
    ("Piotr Zieliński" "Piotr Zielinski")
    ("Po Lu" "Po Lu Via")               ; looks like a mistake
    ("Po Lu" "oldosfan" "luangruo@yahoo\\.com")
    ("Przemysław Wojnowski" "Przemyslaw Wojnowski")
    ("Qifan Wang" "LdBeth" "andpuke@foxmail\\.com")
    ("R. Bernstein" "rb@dustyfeet\\.com")
    ("Rainer Schöpf" "Rainer Schoepf")
    ("Raja R. Harinath" "Raja R Harinath")
    ("Rasmus Pank Roulund" "Rasmus .*rasmus@gmx")
    (nil "rbrtb@")
    ("Richard G. Bielawski" "Richard G Bielawski" "Richard Bielawski")
    ("Richard King" "Dick King")
    ("Richard M. Stallman" "Richard Stallman" "rms@gnu.org")
    (nil "webmaster@robario\\.com")
    ("Robert J. Chassell" "Bob Chassell")
    ("Roberto Huelga Díaz" "Roberto Huelga")
    ("Rodney J. Whitby" "Rod Whitby")
    ("Roland B. Roberts" "Roland B Roberts" "Roland Roberts")
    ("Ron Schnell" "Ronnie Schnell")
    ("Rui-Tao Dong" "Rui-Tao Dong ~{6-HpLN~}")
    ("Ryan Thompson" "Ryan .*rct@thompsonclan")
    (nil "rvs314")
    (nil "rzl24ozi")
    ("Sacha Chua" "Sandra Jean Chua")
    ("Sam Steingold" "Sam Shteingold")
    ("Satyaki Das" "Indexed search by Satyaki Das")
    ("Sébastien Vauban" "Sebastien Vauban")
    ("Sergey Litvinov" "Litvinov Sergey")
    ("Simen Heggestøyl" "simenheg@gmail\\.com")
    (nil "prime.wizard")
    ("Shun-ichi Goto" "Shun-ichi GOTO")
    ;; The trailing dash is a kludge, so this contributor is not ignored.
    ("skykanin-" "skykanin@users\\.noreply\\.github\\.com")
    ;; There are other Stefans.
;;;    ("Stefan Monnier" "Stefan")
    (nil "ssnnoo")
    ("Steven L. Baur" "SL Baur" "Steven L Baur")
    ("Stewart M. Clamen" "Stewart Clamen")
    ("Stuart D. Herring" "Stuart Herring" "Davis Herring")
    ("T.V. Raman" "T\\. V\\. Raman")
    ("Taichi Kawabata" "KAWABATA,? Taichi")
    ("Takaaki Ota" "Tak Ota")
    ("Takahashi Naoto" "Naoto Takahashi")
    ("Teodor Zlatanov" "Ted Zlatanov")
    (nil "^TEC")
    (nil "The PCL-CVS Trust")
    ("Thomas Dye" "Tom Dye")
    ("Thomas Horsley" "Tom Horsley")	; FIXME ?
    ("Thomas Wurgler" "Tom Wurgler")
    (nil "thuna\\.cing@gmail\\.com")
    ("Toby Cubitt" "Toby S\\. Cubitt")
    ("Tomohiko Morioka" "MORIOKA Tomohiko")
    ("Torbjörn Axelsson" "Torbjvrn Axelsson")
    ("Torbjörn Einarsson" "Torbj.*rn Einarsson")
    ("Toru Tomabechi" "Toru TOMABECHI")
    ("Tsugutomo Enami" "enami tsugutomo")
    ("Ulrich Müller" "Ulrich Mueller")
    (nil "vividsnow")
    (nil "Valenoern" "valenoern@distributary\\.network")
    ("Vincent Del Vecchio" "Vince Del Vecchio")
    ("M Visuwesh" "visuweshm@gmail\\.com")
    (nil "vjoki@")
    (nil "whatacold@gmail\\.com")
    ("William M. Perry" "Bill Perry")
    ("Wlodzimierz Bzyl" "W.*dek Bzyl")
    (nil "xyblor")
    ("Yilkal Argaw" "yilkalargaw" "yilkalargawworkneh@gmail\\.com")
    ("Yoni Rabkin" "Yoni Rabkin Katzenell")
    ("Yoshinori Koseki" "KOSEKI Yoshinori" "小関 吉則")
    ("Yuzhana Ego" "YugaEgo" "yet@ego\\.team")
    ("Yutaka NIIBE" "NIIBE Yutaka")
    (nil "stardiviner")
    (nil "lin\\.sun")
    ("Nitish Chinta" "nitishch")
    ("Carlos Pita" "memeplex")
    ("Vinicius Jose Latorre" "viniciusjl")
    ("Gaby Launay" "galaunay")
    ("Dick R. Chiang" "dickmao")
    ("Lin Zhou" "georgealbert@qq\\.com")
    (nil "yan@metatem\\.net")
    (nil "gnu_lists@halloleo\\.hailmail\\.net")
    )
  "Alist of author aliases.

Each entry is of the form (REALNAME REGEXP...).
If an author's full name, as in \"J.R.Hacker <foobar.com>\",
matches one of the REGEXPs, use REALNAME instead.
If REALNAME is nil, ignore that author.")

;; FIXME seems it would be less fragile to check for O', Mc, etc.
(defconst authors-fixed-case
  '("Barry O'Reilly"
    "Brian McKenna"
    "Brian van den Broek"
    "Bryan O'Sullivan"
    "Christian von Roques"
    "Christophe de Dinechin"
    "Craig McDaniel"
    "Daniel LaLiberte"
    "Daniel McClanahan"
    "David J. MacKenzie"
    "David McCabe"
    "David O'Toole"
    "Devon Sean McCullough"
    "Dominique de Waleffe"
    "Theresa O'Connor"
    "Exal de Jesus Garcia Carrillo"
    "George McNinch"
    "Greg McGary"
    "Hans de Graaff"
    "Ivan Vilata i Balaguer"
    "Jae-hyeon Park"
    "James TD Smith"
    "Jay McCarthy"
    "Joel N. Weber II"
    "Matt McClure"
    "Mike McLean"
    "Michael McNamara"
    "Mike McEwan"
    "Nelson Jose dos Santos Ferreira"
    "Peter von der Ahé"
    "Peter O'Gorman"
    "Piet van Oostrum"
    "Roland McGrath"
    "Santiago Payà i Miralta"
    "Sean O'Halpin"
    "Sean O'Rourke"
    "Shun-ichi Goto"
    "Thomas DeWeese"
    "Tijs van Bakel"
    "Titus von der Malsburg"
    "Yu-ji Hosokawa")
  "List of authors whose names cannot be simply capitalized.")

(defvar authors-public-domain-files
  '("emerge\\.el"
    "vi\\.el"
    "feedmail\\.el"
    "mailpost\\.el"
    "hanoi\\.el"
    "meese\\.el"
    "studly\\.el"
    "modula2\\.el"
    "nnmaildir\\.el"
    "nnil\\.el"
    "b2m\\.c"
    "unexhp9k800\\.c"
    "emacsclient\\.1"
    "check-doc-strings")
  "List of regexps matching files for which the FSF doesn't need papers.")


(defvar authors-obsolete-files-regexps
  '(".*loaddefs\\.el\\'"		; not obsolete, but auto-generated
    "\\.\\(bzr\\|cvs\\|git\\)ignore\\'"		; obsolete or uninteresting
    "\\.arch-inventory\\'"
    "ChangeLog\\(\\.[0-9]+\\)?\\'"
    "\\(automated\\|test\\)/data/"	; not interesting
    "cedet/tests/"
    "test/etags/"
    "\\`\\(indent\\|automated\\)\\'" "indent/" "mod-test/"
    "-resources/"
    "unidata/.*\\.txt\\'"
    "BidiCharacterTest\\.txt"
    ;; TODO lib/? Matches other things?
    "build-aux/" "m4/" "Emacs\\.xcodeproj" "mapfiles" "\\.map\\'"
    "preferences\\.\\(nib\\|gorm\\)"
    ;; Generated files that have since been removed.
    "\\(refcard\\(-de\\|-pl\\)?\\|calccard\\|dired-ref\\|orgcard\\|\
gnus-booklet\\|fr-drdref\\)\\.p\\(df\\|s\\)\\'"
    ;; Removed as obsolete
    "README-ftp-server"
    )
  "List of regexps matching obsolete files.
Changes to files matching one of the regexps in this list are not listed.")

(defconst authors-no-scan-regexps
  '("etc/nxml/"
    "test/data/"
    "test/.*-resources/")
  "Lists of regexps matching files not to scan for authorship.")

(defconst authors-ignored-files
  '("external-lisp"
    "lock" "share-lib" "local-lisp"
    "noleim-Makefile.in"
    "NEWS" "ORDERS" "PROBLEMS" "FAQ" "AUTHORS" "release-process" "TODO" "todo"
    "MACHINES" "SERVICE"
    "README.unicode" "README.multi-tty" "TUTORIAL.translators"
    "NEWS.unicode" "COPYING.DJ" "Makefile.old" "Makefile.am"
    "NEWS.1" "OOOOONEWS...OONEWS" "OOOONEWS" "etc/NEWS"
    "NEWS.1-17" "NEWS.18" "NEWS.19" "NEWS.20" "NEWS.21" "NEWS.22"
    "NEWS.23" "NEWS.24" "NEWS.25" "NEWS.26" "NEWS.27" "NEWS.28"
    "MAINTAINERS" "ERC-NEWS" "MH-E-NEWS" "NXML-NEWS"
    "install.sh" "install-sh" "missing" "mkinstalldirs"
    "termcap.dat" "termcap.src" "termcap.ucb" "termcap"
    "ChangeLog.nextstep" "Emacs.clr" "spec.txt"
    "gfdl.1" "ledit.l"
    "texi/Makefile.in"
    "autodeps.mk"
    "lwlib/autodeps.mk"
    "oldXMenu/autodeps.mk"
    "src/autodeps.mk"
    "Imakefile" "icons/sink.ico" "aixcc.lex"
    "nxml/char-name/unicode"
    "spec.txt"
    "js2-mode.el"      ; only installed very briefly, replaced by js.el
    ;; In the old imported lisp/url ChangeLog, but never in Emacs.
    "mule-sysdp.el"
    ;; Only briefly present.
    "tests/gnustest-nntp.el" "tests/gnustest-registry.el"
    "cedet/tests/testtemplates.cpp"
    "cedet/tests/testusing.cpp"
    "cedet/tests/scopetest.cpp"
    "cedet/tests/scopetest.java"
    "cedet/tests/test.cpp"
    "cedet/tests/test.py"
    "cedet/tests/teststruct.cpp"
    "subdirs.el"
    "etc/facemenu-removal.txt"
    "src/bytecode.h"
    "*.el"
    ;; Autogen:
    "cus-load.el" "finder-inf.el" "ldefs-boot.el" "loaddefs-boot.el"
    "lisp/ldefs-boot-manual.el" "lisp/ldefs-boot-auto.el"
    "compile" "config.guess" "config.sub" "depcomp"
    "autogen/compile" "autogen/config.guess" "autogen/config.in"
    "autogen/config.sub" "autogen/depcomp" "autogen/install-sh"
    "autogen/missing" "autogen"
    "autogen/copy_autogen" ; not generated, but trivial and now removed
    "dir_top"
    ;; Imported into Emacs but externally maintained.
    "publicsuffix.txt" "SKK-JISYO.L"
    ;; Only existed briefly, then renamed:
    "images/icons/allout-widgets-dark-bg"
    "images/icons/allout-widgets-light-bg"
    "lisp/shorthand.el"
    "test/lisp/shorthand-tests.el"
    "lisp/shorthands.el"
    "test/src/comp-test-funcs.el"
    "lisp/net/link.el"
    "lisp/net/connection.el"
    "lisp/net/dictionary-link.el"
    "test/src/comp-test-funcs-dyn.el"
    ;; Never had any meaningful changes logged, now deleted:
    "lib/stdarg.in.h" "lib/stdbool.in.h"
    "unidata/bidimirror.awk" "unidata/biditype.awk"
    "split-man" "Xkeymap.txt" "ms-7bkermit" "ulimit.hack"
    "gnu-hp300" "refcard.bit" "forms.README" "forms-d2.dat"
    "CXTERM-DIC/PY.tit" "CXTERM-DIC/ZIRANMA.tit"
    "CXTERM-DIC/CTLau.tit" "CXTERM-DIC/CTLauB.tit"
    "copying.paper" "celibacy.1" "condom.1" "echo.msg" "sex.6"
    "COOKIES" "INTERVIEW" "MAILINGLISTS" "MOTIVATION"
    "NICKLES.WORTH" "INTERVAL.IDEAS" "RCP"
    "3B-MAXMEM" "AIX.DUMP" "SUN-SUPPORT" "XENIX"
    "CODINGS" "CHARSETS"
    "calc/INSTALL" "calc/Makefile" "calc/README.prev"
    "vms-pp.trans" "_emacs" "batcomp.com" "notes/cpp" ; admin/
    "notes/BRANCH" "notes/exit-value"
    "emacsver.texi.in"
    "vpath.sed"
    "Cocoa/Emacs.base/Contents/Info.plist"
    "Cocoa/Emacs.base/Contents/Resources/English.lproj/InfoPlist.strings"
    "GNUstep/Emacs.base/Resources/Info-gnustep.plist"
    "GNUstep/Emacs.base/Resources/Emacs.desktop"
    "Cocoa/Emacs.base/Contents/Resources/English.lproj"
    ;; Only existed briefly, then deleted:
    "coccinelle/overlay.cocci" "coccinelle/symbol.cocci"
    ;; MH-E stuff not in Emacs:
    "import-emacs" "release-utils"
    ;; Erc stuff not in Emacs:
    "ChangeLog.2001" "ChangeLog.2002" "ChangeLog.2003" "ChangeLog.2004"
    "ChangeLog.2005"
    "README.extras" "dir-template" "mkChangeLog" "MkChangeLog" "erc-auto.in"
    "CREDITS" "HACKING"
    "debian/changelog"
    "debian/control"
    "debian/copyright"
    "debian/maint/conffiles"
    "debian/maint/conffiles.in"
    "debian/maint/postinst"
    "debian/maint/postinst.in"
    "debian/maint/prerm"
    "debian/maint/prerm.in"
    "debian/README.Debian"
    "debian/README.erc-speak"
    "debian/rules"
    "debian/scripts/install"
    "debian/scripts/install.in"
    "debian/scripts/remove"
    "debian/scripts/remove.in"
    "debian/scripts/startup"
    "debian/scripts/startup.erc"
    "debian/scripts/startup.erc-speak"
    ;; Used to be in admin, not very interesting.
    "emacs-pretesters" "make-announcement" "make-changelog-diff" "admin/FOR-RELEASE" "etc/FOR-RELEASE" "nextstep/FOR-RELEASE" "FOR-RELEASE"
    ;; Textual comments that are not files.
    "All" "Version" "Everywhere" "Many" "Various" "files"
    ;; Directories.
    "vms" "mac" "url" "tree-widget"
    "info/dir"
    ;; Not in gnulib anymore
    "lib/qset-acl.c" "lib/qcopy-acl.c" "lib/file-has-acl.c" "lib/secure_getenv.c"
    "lib/malloca.c" "lib/malloca.h"
    ;; Briefly added to repository from gnulib, but not used
    "lib/localtime-buffer.c"
    "lib/localtime-buffer.h"
    ;; files from old MS Windows build procedures
    "nt/gnulib-modules-to-delete.cfg"
    "makefile.w32-in"
    "admin/unidata/makefile.w32-in"
    "unidata/makefile.w32-in"
    "lib/makefile.w32-in"
    "lib-src/makefile.w32-in"
    "leim/makefile.w32-in"
    "lisp/makefile.w32-in"
    "src/makefile.w32-in"
    "nt/emacs-src.tags"
    "doc/emacs/makefile.w32-in"
    "doc/lispintro/makefile.w32-in"
    "doc/lispref/makefile.w32-in"
    "doc/misc/makefile.w32-in"
    "nt/paths.h"
    "paths.h"
    "src/paths.h"
    "envadd.bat"
    "multi-install-info.bat"
    "INSTALL.OLD" "nt/INSTALL.OLD"
    "nt/src/paths.h"
    "nmake.defs"
    "gmake.defs"
    "zipdist.bat"
    "nt/makefile.w32-in"
    "nt/subdirs.el"
    "config.nt"
    "nextstep/WISHLIST"
    ;; Removed, replaced by gitmerge.el
    "admin/bzrmerge.el"
    "bzrmerge.el"
    ;; Removed in commit f5090b91299
    "lib/fdatasync.c"
    ;; Removed as obsolete
    "nt/README-ftp-server"
    "admin/notes/font-backend"
    "gnus-overrides.texi"
    "CENSORSHIP"
    "GNU"
    "LINUX-GNU"
    "THE-GNU-PROJECT"
    "WHY-FREE"
    "MORE.STUFF"
    "notes/font-backend"
    "src/ftxfont.c"
    "ftxfont.c"
    "src/ptr-bounds.h"
    "obsolete/options.el"
    "obsolete/old-whitespace.el"
    "obsolete/lucid.el"
    "lisp/obsolete/fast-lock.el"
    "lisp/obsolete/lazy-lock.el"
    "lisp/obsolete/pc-mode.el"
    ;; ada-mode has been deleted, now in GNU ELPA
    "ada-mode.texi"
    "doc/misc/ada-mode.texi"
    "lisp/progmodes/ada-mode.el"
    "lisp/progmodes/ada-prj.el"
    "lisp/progmodes/ada-xref.el"
    "GNUS-NEWS"
    "etc/GNUS-NEWS"
    "doc/misc/gnus-news.el"
    "src/fingerprint-dummy.c"
    "src/fingerprint.h"
    ;; Replaced by lisp/thread.el
    "lisp/emacs-lisp/thread-list.el"
    "etc/images/slash.bmp"
    "src/mini-gmp-emacs.c"
    "lib/dosname.h"
    "lib/putenv.c"
    ;; Moved to the org-contrib repo
    "ob-asymptote.el"
    "ob-shen.el"
    "ob-picolisp.el"
    "ob-io.el"
    "ob-mscgen.el"
    "ob-ledger.el"
    "lisp/org/ob-abc.el"
    "lisp/org/ob-ebnf.el"
    "lisp/org/ob-J.el"
    ;; Removed -- for now.
    "test/src/doc-tests.el"
    )
  "List of files and directories to ignore.
Changes to files in this list are not listed.")

;; List via: find . -name '*.el' | sed 's/.*\///g' | sort | uniq -d
;; FIXME It would be better to discover these dynamically.
(defconst authors-ambiguous-files
  '("Makefile.in"
    "makefile.w32-in"
    "chart.el"
    "cl-lib.el"
    "compile.el"
    "complete.el"
    "cpp.el"
    "ctxt.el"
    "custom.el"
    "cyrillic.el"
    "czech.el"
    "debug.el"
    "dired.el"
    "el.el"
    "eshell.el"
    "ethiopic.el"
    "f90.el"
    "files.el"
    "find.el"
    "format.el"
    "generic.el"
    "georgian.el"
    "grammar.el"
    "greek.el"
    "grep.el"
    "hebrew.el"
    "imenu.el"
    "indian.el"
    "info-xref.el"
    "japanese.el"
    "java.el"
    "lao.el"
    "linux.el"
    "locate.el"
    "make.el"
    "mode.el"
    "mule-util.el"
    "python.el"
    "rmailmm.el"
    "semantic.el"
    "shell.el"
    "simple.el"
    "slovak.el"
    "sort.el"
    "speedbar.el"
    "srecode.el"
    "table.el"
    "texi.el"
    "thai.el"
    "thingatpt.el"
    "tibetan.el"
    "util.el"
    "vc-bzr.el"
    "wisent.el")
  "List of basenames occurring more than once in the source.")

;; FIXME :cowrote entries here can be overwritten by :wrote entries
;; derived from a file's Author: header (eg mh-e).  This really means
;; the Author: header is erroneous.
(defconst authors-fixed-entries
  '(("Richard M. Stallman" :wrote "[The original GNU Emacs and numerous files]")
    ("Joseph Arceneaux" :wrote "xrdb.c")
    ;; This refers to the obsolete Willisson (qv) version.
;;;    ("Blitz Product Development Corporation" :wrote "ispell.el")
    ("Frank Bresz" :wrote "diff.el")
    ("David M. Brown" :wrote "array.el")
    ;; No longer distributed.
;;;    ("Gary Byers" :changed "xenix.h")
    ;; No longer distributed: freebsd.h
    ;; Only trivial pieces remain, merged into configure.ac.
    ("Shawn M. Carey" :wrote "[some early FreeBSD support]")
    ;; hp800.h renamed from hp9000s800.h, hpux.h merged into hpux10-20.h.
    ;; FIXME overwritten by Author:.
    ("Satyaki Das" :cowrote "mh-search.el")
    ;; No longer distributed: hp800.h, hpux10-20.h.
    ;; Only trivial pieces remain, merged into configure.ac.
    ("Eric Decker" :changed "sysdep.c (and other files for HP-UX support)")
    ("Lawrence R. Dodd" :cowrote "dired-x.el")
    ;; No longer distributed.
;;;    ("Viktor Dukhovni" :wrote "unexsunos4.c")
    ("Paul Eggert" :wrote "rcs2log") ; "vcdiff"
    ("Fred Fish" :changed "unexcoff.c")
    ;; No longer distributed.
;;;    ("Tim Fleehart" :wrote "makefile.nt")
    ("Keith Gabryelski" :wrote "hexl.c")
    ("Kevin Gallagher" :wrote "flow-ctrl.el")
    ;; Also wrote an earlier version of disp-table.el, since replaced
    ;; by Erik Naggum's version; also iso-syntax.el, later renamed to
    ;; latin-1.el, since deleted.
    ("Howard Gayle" :wrote "casetab.c")
    ;; :wrote mh-pick.el, since merged into mh-search.el.
    ;; Originally wrote mh-funcs.el, but it has been rewritten since.
    ("Stephen Gildea" :wrote "refcard.tex"
     :cowrote "mh-funcs.el" "mh-search.el")
    ;; cl.texinfo renamed to cl.texi.
    ("David Gillespie" :wrote "cl.texi")
    ;; No longer distributed: emacsserver.c.
    ("Hewlett-Packard" :changed "emacsclient.c" "server.el" "keyboard.c")
    ;; No longer distributed.
;;;    ("Thomas Horsley" :wrote "cxux.h" "cxux7.h")
    ("Indiana University Foundation" :changed "buffer.c" "buffer.h"
     "indent.c" "search.c" "xdisp.c" "region-cache.c" "region-cache.h")
    ;; ibmrt.h, ibmrt-aix.h no longer distributed.
    ("International Business Machines" :changed "emacs.c" "fileio.c"
     "process.c" "sysdep.c" "unexcoff.c")
    ;; No longer distributed.
;;;    ("Ishikawa Chiaki" :changed "aviion.h" "dgux.h")
    ;; No longer distributed: ymakefile, intel386.h, mem-limits.h, template.h,
    ;; linux.h (was renamed to lignux.h, then to gnu-linux.h, then removed)
    ("Michael K. Johnson" :changed "configure.ac" "emacs.c"
     "process.c" "sysdep.c" "syssignal.h" "systty.h" "unexcoff.c")
    ;; No longer distributed.
;;;    ("Kyle Jones" :wrote "mldrag.el")
    ("Henry Kautz" :wrote "bib-mode.el")
    ;; No longer distributed: vms-pwd.h, vmsfns.c, uaf.h,
    ;; dir.h (was renamed to vmsdir.h, then removed)
    ("Joseph M. Kelsey" :changed "fileio.c")
    ("Sam Kendall" :changed "etags.c" "etags.el")
    ;; ack.texi: "We're not using his backquote.el any more."
    ("Richard King" :wrote "userlock.el" "filelock.c")
    ("Sebastian Kremer" :changed "add-log.el")
    ("Mark Lambert" :changed "process.c" "process.h")
    ("Aaron Larson" :changed "bibtex.el")
    ;; It was :wrote, but it has been rewritten since.
    ("James R. Larus" :cowrote "mh-e.el")
    ("Lars Lindberg" :changed "dabbrev.el" :cowrote "imenu.el")
    ;; No longer distributed: lselect.el.
    ("Lucid, Inc." :changed "bytecode.c" "byte-opt.el" "byte-run.el"
     "bytecomp.el" "delsel.el" "disass.el" "faces.el" "font-lock.el"
     "mailabbrev.el" "select.el" "xfaces.c" "xselect.c")
    ;; MCC.  No longer distributed: emacsserver.c.
    ("Microelectronics and Computer Technology Corporation"
     :changed "etags.c" "emacsclient.c" "movemail.c"
     "rmail.el" "rmailedit.el" "rmailkwd.el"
     "rmailmsc.el" "rmailout.el" "rmailsum.el" "scribe.el"
     ;; It was :wrote for xmenu.c, but it has been rewritten since.
     "server.el" "lisp.h" "sysdep.c" "unexcoff.c" "xmenu.c")
    ("Niall Mansfield" :changed "etags.c")
    ("Brian Marick" :cowrote "hideif.el")
    ("Marko Kohtala" :changed "info.el")
    ("Sidney Markowitz" :changed "doctor.el")
    ;; No longer distributed: env.c.
    ("Richard Mlynarik" :wrote "ehelp.el")
    ("Mosur Mohan" :changed "etags.c")
    ("Jeff Morgenthaler" :changed "flow-ctrl.el" "vt200.el" "vt201.el"
     "vt220.el" "vt240.el")
    ("Motorola" :changed "buff-menu.el")
    ("Hiroshi Nakano" :changed "ralloc.c")
    ;; File removed in Emacs 24.1.
;;;    ("Sundar Narasimhan" :changed "rnewspost.el")
    ;; No longer distributed.
;;;    ("NeXT, Inc." :wrote "unexnext.c")
    ("Mark Neale" :changed "fortran.el")
    ;; Renamed from sc.el.
    ("Martin Neitzel" :changed "supercite.el")
    ("Andrew Oram" :changed "calendar.texi (and other doc files)")
    ("Frederic Pierresteguy" :wrote "widget.c")
    ("Michael D. Prange" :changed "tex-mode.el")
    ;; No longer distributed (dgux5-4r3.h was renamed to dgux5-4-3.h).
;;;    ("Paul Reilly" :wrote "gux5-4r2.h" "dgux5-4-3.h")
    ("Rob Riepel" :wrote "tpu-edt.doc")
    ("Roland B. Roberts" :changed "files.el" "sort.el"
     "buffer.h" "callproc.c" "dired.c" "process.c" "sysdep.c" "systty.h")
     ;; No longer distributed.
;;;     "vmspaths.h" "build.com" "compile.com" "kepteditor.com" "precomp.com"
;;;     "vmsproc.el" :wrote "logout.com" "mailemacs.com")
;;;    ("Guillermo J. Rozas" :wrote "fakemail.c")
    ("Wolfgang Rupprecht" :changed "lisp-mode.el" "loadup.el"
     "sort.el" "alloc.c" "callint.c"
     ;; config.in renamed from config.h.in, now a generated file.
     ;; ecrt0.c renamed from crt0.c, then removed.
     "data.c" "fns.c"
     "lisp.h" "lread.c" ; "sun3.h" "ymakefile" - no longer distributed
     "print.c" :wrote "float-sup.el" "floatfns.c")
    ("Schlumberger Technology Corporation" :changed "gud.el")
    ;; Replaced by tcl.el.
;;;    ("Gregor Schmid" :wrote "tcl-mode.el")
    ;; No longer distributed since 24.1.
;;;    ("Rainer Schöpf" :wrote "alpha.h" "unexalpha.c")
    ;; No longer distributed: emacsserver.c.
    ("William Sommerfeld" :wrote "emacsclient.c" "scribe.el")
    ;; No longer distributed: emacsserver.c.
    ("Leigh Stoller" :changed "emacsclient.c" "server.el")
    ("Steve Strassmann" :wrote "spook.el")
    ("Shinichirou Sugou" :changed "etags.c")
    ;; No longer distributed: emacsserver.c.
    ("Sun Microsystems, Inc" :changed "emacsclient.c" "server.el"
     :wrote "emacs.icon" "sun.el")
    ;; No longer distributed.
;;;     "emacstool.1" "emacstool.c" "sun-curs.el"
;;;     "sun-fns.el" "sun-mouse.el" "sunfns.c")
    ;; Renamed from sc.el.
    ("Kayvan Sylvan" :changed "supercite.el")
    ;; No longer distributed: emacsserver.c, tcp.c.
    ("Spencer Thomas" :changed "emacsclient.c" "server.el"
     "dabbrev.el" "unexcoff.c" "gnus.texi")
    ("Jonathan Vail" :changed "vc.el")
    ;; No longer distributed: usg5-4.h
    ("James Van Artsdalen" :changed "unexcoff.c")
    ;; No longer distributed: src/makefile.nt, lisp/makefile.nt
    ;; winnt.el renamed to w32-fns.el; nt.[ch] to w32.[ch];
    ;; ntheap.[ch] to w32heap.[ch]; ntinevt.c to w32inevt.c;
    ;; ntproc.c to w32proc.c; ntterm.c to w32term.c;
    ;; windowsnt.h to ms-w32.h.
    ("Geoff Voelker" :wrote "w32-fns.el" "w32.c" "w32.h" "w32heap.c"
     "w32heap.h" "w32inevt.c" "w32proc.c" "w32term.c" "ms-w32.h")
    ("Bob Weiner" :changed "dframe.el" "etags.c" "info.el" "quail.el"
     "rmail.el" "rmailsum.el" "speedbar.el")
    ("Morten Welinder" :wrote "dosfns.c" "[many MS-DOS files]" "msdos.h")
    ("Eli Zaretskii" :wrote "bidi.c" "[bidirectional display in xdisp.c]"
     "[tty menus in term.c]")
    ;; Not using this version any more.
;;;    ("Pace Willisson" :wrote "ispell.el")
    ;; FIXME overwritten by Author:.
    ("Bill Wohler" :cowrote "mh-e.el")
    ("Garrett Wollman" :changed "sendmail.el")
    ("Dale R. Worley" :changed "mail-extr.el")
    ("Jamie Zawinski" :changed "bytecode.c" :wrote "tar-mode.el"
     :cowrote "disass.el"))
  "Actions taken from the original, manually (un)maintained AUTHORS file.")


(defconst authors-valid-file-names
  '("aclocal.m4"
    "build-ins.in"
    "Makefile"
    "Makefile.noleim"
    "makedist.bat"
    "makefile.def"
    "makefile.nt"
    "ns.mk"
    "README"
    ;; There were a few of these, not just the generated top-level one.
    "configure" "config.h"
    "is_exec.c" "sigaction.c"
    ;; nt/
    "config.nt" "gmake.defs" "gnulib.mk" "nmake.defs"
    "ebuild.bat" "envadd.bat" "fast-install.bat" "install.bat"
    "multi-install-info.bat" "zipdist.bat"
    "debug.bat.in" "emacs.bat.in" "addsection.c"
    "inc/sys/dir.h" "inc/gettext.h" "nt/inc/socket.h"
    "time.h"
    ".gdbinit-union"
    "alloca.s"
    "make-delta"
    "config.w95"
    "msysconfig.sh"
    "emacstool.1"
    "align.umax"
    "cxux-crt0.s"
    "gould-sigvec.s"
    "getdate.y"
    "ymakefile"
    "permute-index" "index.perm"
    "ibmrs6000.inp"
    "b2m.c" "b2m.1" "b2m.pl" "rcs-checkin.1"
    "emacs.bash" "emacs.csh" "ms-kermit"
    "emacs.ico"
    "emacs21.ico"
    "emacs.py" "emacs2.py" "emacs3.py"
    "BABYL" "LPF" "LEDIT" "OTHER.EMACSES"
    "emacs16_mac.png" "emacs24_mac.png"
    "emacs256_mac.png" "emacs32_mac.png"
    "emacs48_mac.png" "emacs512_mac.png"
    "ps-prin2.ps" "ps-prin3.ps"
    "emacs.xbm" "gnu.xpm" "gnus-pointer.xbm" "gnus-pointer.xpm"
    ;; Moved from etc/ to etc/images, and/or removed.
    "gnus.pbm" "gnus.xbm" "gnus.xpm" "letter.pbm" "letter.xbm" "letter.xpm"
    "splash.pbm" "splash.xbm" "splash.xpm" "splash8.xpm"
    "images/execute.pbm" "images/execute.xpm" "images/fld-open.pbm"
    "images/fld-open.xpm" "images/highlight.pbm" "images/highlight.xpm"
    "images/mail.pbm" "images/mail.xpm" "images/mail/alias.pbm"
    "images/mail/alias.xpm" "images/mail/refile.pbm"
    "images/mail/refile.xpm" "images/page-down.pbm"
    "images/page-down.xpm" "images/widen.pbm" "images/widen.xpm"
    "images/gnus/bar.xbm" "images/gnus/bar.xpm"
    "images/gnus/reverse-smile.xpm"
    "notes/commits" "notes/changelogs"
    "revdiff"				; admin/
    "admin/ldefs-clean.el"
    "vcdiff" "rcs-checkin" "tindex.pl"
    "mainmake" "sed1.inp" "sed2.inp" "sed3.inp" ; msdos/
    "mac-fix-env.m"
    ;; Deleted vms stuff:
    "temacs.opt" "descrip.mms" "compile.com" "link.com"
    "compact.el" "fadr.el"
    "calc/calc-maint.el"
    "emacs-lisp/cl-specs.el"
    "emacs-lisp/eieio-comp.el"
    "emacs-lisp/eieio-generic.el"
    "erc-hecomplete.el"
    "eshell/esh-maint.el"
    "language/persian.el"
    "meese.el" "iswitchb.el" "longlines.el"
    "mh-exec.el" "mh-init.el" "mh-customize.el"
    "net/zone-mode.el" "xesam.el"
    "term/mac-win.el" "sup-mouse.el"
    "term/apollo.el"
    "term/vt102.el" "term/vt125.el" "term/vt201.el" "term/vt220.el"
    "term/vt240.el" "term/vt300.el" "term/vt320.el" "term/vt400.el"
    "term/vt420.el"
    "url-https.el"
    "org-mac-message.el" "org-mew.el" "org-w3m.el" "org-vm.el" "org-wl.el"
    "org-mks.el" "org-remember.el" "org-xoxo.el" "org-docbook.el"
    "org-freemind.el" "ox-jsinfo.el"
    "org-irc.el" "org-rmail.el" "org-docview.el" "org-keys.el" "org-mhe.el"
    "org-gnus.el" "org-bibtex.el" "org-bbdb.el" "org-info.el" "org-eshell.el"
    "ob-keys.el"
    "org-exp-blocks.el"		     ; maybe this is ob-exp now? dunno
    "org-lparse.el"
    "org-special-blocks.el" "org-taskjuggler.el"
    "ob-sh.el"
    "ob-scala.el"
    "progmodes/cap-words.el"
    "w32-common-fns.el"
    ;; gnus
    "nnwfm.el" "nnlistserv.el" "nnkiboze.el" "nndb.el" "nnsoup.el"
    "netrc.el" "password.el" "sasl-cram.el" "sasl-digest.el" "sasl-ntlm.el"
    "sasl.el" "dig.el" "dns.el" "hex-util.el" "sha1.el" "md4.el"
    "hmac-def.el" "hmac-md5.el" "ntlm.el" "hashcash.el" "smime-ldap.el"
    "assistant.el" "gnus-utils.el" "tls.el" "pgg-def.el" "pgg-gpg.el"
    "gnus-compat.el" "pgg-parse.el" "pgg-pgp.el" "pgg-pgp5.el" "pgg.el"
    "dns-mode.el" "run-at-time.el" "gnus-encrypt.el" "sha1-el.el"
    "gnus-gl.el" "gnus.sum.el" "proto-stream.el" "color.el" "color-lab.el"
    "earcon.el" "gnus-audio.el" "encrypt.el"
    "gnus-move.el" "gnus-sync.el"
    "gnus-ems.el"
    ;; doc
    "getopt.c" "texindex.c" "news.texi" "vc.texi" "vc2-xtra.texi"
    "back.texi" "vol1.texi" "vol2.texi" "elisp-covers.texi" "two.el"
    "front-cover-1.texi" "locals.texi" "calendar.texi" "info-stnd.texi"
    "tasks.texi"
    "advice.texi" "picture.texi" "texinfo.tex"
    ;; lwlib:
    "dispatch.c" "dispatch.h" "xrdb-cpp.c" "xrdb.c"
    "lwlib-Xol.c" "lwlib-Xol.h" "lwlib-Xolmb.c" "lwlib-Xolmb.h"
    "lwlib-XolmbP.h"
    ;; lib/
    "lib/stdio.c" "lib/gl_openssl.h" "lib/sigprocmask.c"
    "lib/pthread_sigprocmask.c" "lib/ldtoastr.c" "lib/dummy.c"
    "lib/ignore-value.h" "lib/Makefile.am"
    "lib/pathmax.h" "lib/stat.c" "lib/strtoul.c" "lib/strtoull.c"
    "lib/strtoumax.c" "lib/unsetenv.c"
    "lib/getopt_cdefs.in.h" "lib/getopt_core.h" "lib/getopt_ext.h"
    "lib/getopt_pfx_core.h" "lib/getopt_pfx_ext.h"
    ;; lib-src/
    "cvtmail.c" "digest-doc.c" "emacsserver.c" "emacstool.c" "env.c"
    "etags-vmslib.c" "fakemail.c" "getdate.c" "getopt.h" "getopt1.c"
    "getopt_.h" "getopt_int.h" "gettext.h" "leditcfns.c" "loadst.c"
    "make-path.c" "qsort.c" "sorted-doc.c" "tcp.c" "timer.c" "wakeup.c"
    "yow.c" "grep-changelog" "grep-changelog.1"
    ;; semantic files now removed from the repository
    "semantic/bovine/c-by.el" "semantic/bovine/make-by.el"
    "semantic/bovine/scm-by.el" "semantic/wisent/javat-wy.el"
    "semantic/wisent/js-wy.el" "semantic/wisent/python-wy.el"
    "srecode/srt-wy.el"
    ;; etc/
    "emacsclient.c" "etags.c" "hexl.c" "make-docfile.c" "movemail.c"
    "test-distrib.c" "testfile"
    "tpu-edt.doc"			; see below
    ;; etc/images/gnus/
    "etc/images/gnus/important.pbm"
    "etc/images/gnus/receipt.pbm"
    "etc/images/gnus/unimportant.pbm"
    "iso-swed.el"
    ;; lisp/obsolete/
    "lisp/obsolete/vc-mcvs.el"
    "obsolete/vc-mcvs.el"
    "lisp/obsolete/patcomp.el"
    "lisp/obsolete/abbrevlist.el"
    "lisp/obsolete/assoc.el"
    "obsolete/assoc.el"
    "lisp/obsolete/complete.el"
    "lisp/obsolete/cust-print.el"
    "lisp/obsolete/erc-hecomplete.el"
    "lisp/obsolete/mailpost.el"
    "obsolete/mailpost.el"
    "lisp/obsolete/mouse-sel.el"
    "lisp/obsolete/old-emacs-lock.el"
    "obsolete/old-emacs-lock.el"
    "lisp/obsolete/patcomp.el"
    "lisp/obsolete/pc-select.el"
    "lisp/obsolete/s-region.el"
    "obsolete/pc-select.el"
    "nnwarchive.el"
    "nnultimate.el"
    "nnslashdot.el"
    "keyswap.el"
    "mouse-sel.el"
    "nxml-glyph.el"
    "tramp-gw.el"
    "webmail.el"
    "biditest.el"
    "redisplay-testsuite.el"
    "cedet-utests.el" "ede-tests.el" "semantic-ia-utest.el"
    "semantic-tests.el" "semantic-utest-c.el" "semantic-utest.el"
    "srecode-tests.el" "make-test-deps.emacs-lisp"
    "nxml-uchnm.el"
    "decoder-tests.el"
    "obsolete/scribe.el"
    "cp51932.el"
    "eucjp-ms.el"
    "lisp.mk"
    "update-game-score.exe.manifest"
    "lisp/obsolete/awk-mode.el"
    "lisp/obsolete/iso-acc.el"
    "lisp/obsolete/iso-insert.el"
    "lisp/obsolete/resume.el"
    "lisp/obsolete/scribe.el"
    "lisp/obsolete/swedish.el"
    "lisp/obsolete/spell.el"
    "lisp/obsolete/swedish.el"
    "lisp/obsolete/sym-comp.el"
    "obsolete/sym-comp.el"
    "library-of-babel.org"
    "flymake-elisp.el"
    "flymake-ui.el"
    "pinentry.el"
    "ledit.el"
    "lmenu.el"
    "src/pgtkselect.h"
    "test/manual/noverlay/many-errors.h"
    "lisp/better-pixel-scroll.el"
    "test/infra/default-gitlab-ci.yml"
    "test/infra/test-jobs-generator.sh"
    "org-install.el"
    ;; use-package stuff removed after it was added
    "etc/USE-PACKAGE-NEWS"
    "lisp/use-package/bind-chord.el"
    "lisp/use-package/use-package-chords.el"
    "lisp/use-package/use-package-chords-tests.el"
    "test/lisp/use-package/use-package-chords-tests.el"
    ;; Eglot stuff removed after it was added
    "README.mdown"
    "README.md"
    ".travis.yml"
    ;; Tree-sitter stuff
    "admin/notes/tree-sitter/html-manual/Parser_002dbased-Font-Lock.html"
    "admin/notes/tree-sitter/html-manual/Parsing-Program-Source.html"
    "admin/notes/tree-sitter/html-manual/build-manual.sh"
    "admin/notes/tree-sitter/html-manual/Accessing-Node.html"
    "admin/notes/tree-sitter/html-manual/Language-Definitions.html"
    "admin/notes/tree-sitter/html-manual/Multiple-Languages.html"
    "admin/notes/tree-sitter/html-manual/Parser_002dbased-Indentation.html"
    "admin/notes/tree-sitter/html-manual/Pattern-Matching.html"
    "admin/notes/tree-sitter/html-manual/Retrieving-Node.html"
    "admin/notes/tree-sitter/html-manual/Tree_002dsitter-C-API.html"
    "admin/notes/tree-sitter/html-manual/Using-Parser.html"
    "admin/notes/tree-sitter/html-manual/manual.css"
    "admin/notes/tree-sitter/build-module/build.sh"
    "admin/notes/tree-sitter/build-module/batch.sh"
    "doc/misc/gnus-coding.texi"
    "gnus-coding.texi"
    )
  "File names which are valid, but no longer exist (or cannot be found)
in the repository.")

;; Note that any directory part on the RHS is retained.
;; Cf authors-renamed-files-regexps.
;; NB So only add a directory if needed to disambiguate.
;; FIXME?
;; Although perhaps we could let authors-disambiguate-file-name do that?
;;
;; WARNING: The semantics of these entries is tricky to grasp without
;; reading the code!
;; The rule is: for every file that was renamed or moved to another
;; directory, add an entry (OLD-NAME . NEW-BASENAME), where OLD-NAME
;; is the old name of the file as it appears in the ChangeLog files,
;; and NEW-BASENAME is the _basename_ of its new name.  Yes, this
;; means that a file which was moved to another directory but kept its
;; basename will have a seemingly-silly entry ("foo" . "foo").  (Told
;; you: this is tricky!)  If the moved/renamed file was mentioned in
;; several ChangeLog files with different leading directories, you
;; need to provide an entry for each such instance.  For example, if
;; some ChangeLog mentioned a moved file as lisp/gnus/something.el and
;; another ChangeLog mentioned it as gnus/something.el, you need to
;; have two entries:
;;
;;     ("gnus/something.el" . "something.el")
;;     ("lisp/gnus/something.el" . "something.el")
;;
;; The important part is that the car of the entry should be identical
;; to how a file was mentioned in the respective ChangeLog.  It is
;; advisable to run a Grep command such as
;;
;;   grep -F -R BASENAME . --include='ChangeLog*'
;;
;; where BASENAME is the old basename of the renamed file.  This will
;; show all the different reference forms of the file in the various
;; ChangeLog* files, and you can then prepare a separate entry for
;; each reference form.
;;
;; The cdr of the entry should generally be only the basename of the
;; file's current name, because that's how AUTHORS references files.
;; It _can_ have leading directories, but that is only
;; needed/advisable if there are several files in the tree that have
;; the same basename, and you want to disambiguate them, so that
;; people who actually contributed to different files aren't mentioned
;; as if they contributed to the same single file.
(defconst authors-renamed-files-alist
  '(("nt.c" . "w32.c") ("nt.h" . "w32.h")
    ("ntheap.c" . "w32heap.c") ("ntheap.h" . "w32heap.h")
    ("ntinevt.c" . "w32inevt.c") ("ntinevt.h" . "w32inevt.h")
    ("ntproc.c" . "w32proc.c")
    ("w32console.c" . "w32term.c")
    ("unexnt.c" . "unexw32.c")
    ("m/windowsnt.h" . "ms-w32.h")
    ("s/windowsnt.h" . "ms-w32.h")
    ("s/ms-w32.h" . "ms-w32.h")
    ("src/config.h" . "config.h")
    ("winnt.el" . "w32-fns.el")
    ("linux.h" . "gnu-linux.h")
    ("emacs.manifest" . "emacs-x86.manifest")
    ("config.emacs" . "configure")
    ("configure.in" . "configure.ac")
    ("config.h.dist" . "config.in")
    ("config.h-dist" . "config.in")
    ("config.h.in" . "config.in")
    ("debug.bat" . "debug.bat.in")
    ("emacs.bat" . "emacs.bat.in")
    ;; paths.h.dist -> paths.h-dist -> paths.h.in -> paths.in -> epaths.in.
    ("paths.h.dist" . "epaths.in")
    ("paths.h-dist" . "epaths.in")
    ("paths.h.in" . "epaths.in")
    ("paths.in" . "epaths.in")
    ("emacs.rc" . "emacs.rc.in")
    ("emacsclient.rc" . "emacsclient.rc.in")
    ("patch1" . "sed1.inp")
    ("INSTALL.MSYS" . "INSTALL")
    ("server.c" . "emacsserver.c")
    ("lib-src/etags.c" . "etags.c")
    ;; gnulib
    ("lib/strftime.c" . "nstrftime.c")
    ("src/mini-gmp.c" . "mini-gmp.c")
    ("src/mini-gmp.h" . "mini-gmp.h")
    ;; msdos/
    ("is-exec.c" . "is_exec.c")
    ("enriched.doc" . "enriched.txt")
    ("GETTING.GNU.SOFTWARE" . "FTP")
    ("etc/MACHINES" . "MACHINES")
    ("ONEWS" . "NEWS.19")
    ("ONEWS.1" . "NEWS.1-17")
    ("ONEWS.2" . "NEWS.1-17")
    ("ONEWS.3" . "NEWS.18")
    ("ONEWS.4" . "NEWS.18")
    ("ORDERS.USA" . "ORDERS")
    ("EUROPE" . "ORDERS")
    ("DIFF" . "OTHER.EMACSES")
    ("CCADIFF" . "OTHER.EMACSES")
    ("GOSDIFF" . "OTHER.EMACSES")
    ("emacs.appdata.xml" . "emacs.metainfo.xml")
    ;; Nextstep
    ("nextstep/Cocoa/Emacs.base/Contents/Info.plist" . "nextstep/templates/Info.plist.in")
    ;; Moved from lisp/tpu-doc.el to etc/tpu-edt.doc in Emacs 19.29.
    ;; Removed in Emacs 19.30, replaced by new file etc/edt-user.doc
    ;; (no associated ChangeLog entry).
    ("tpu-doc.el" . "tpu-edt.doc")
    ("Makefile.in.in" . "Makefile.in")
    ("leim-Makefile" . "leim/Makefile")
    ("leim-Makefile.in" . "leim/Makefile.in")
    ("emacs-lisp/testcover-ses.el" . "tcover-ses.el")
    ("emacs-lisp/testcover-unsafep.el" . "tcover-unsafep.el")
    ("progmodes/dos.el" . "bat-mode.el")
    ;; index and pick merged into search.
    ("mh-index.el" . "mh-search.el")
    ("mh-pick.el" . "mh-search.el")
    ("font-setting.el" . "dynamic-setting.el")
    ("help-funs.el" . "help-fns.el")
    ("erc-notifications.el" . "erc-desktop-notifications.el")
    ("org-complete.el" . "org-pcomplete.el")
    ("org-export.el" . "ox.el")		; ?
    ;; Was definitely renamed to org-latex.el, then... ?
    ("org-export-latex.el" . "ox-latex.el") ; ?
    ("org-exp.el" . "ox.el")		    ; ?
    ("progmodes/cfengine3.el" . "cfengine.el")
    ("progmodes/delphi.el" . "opascal.el")
    ("octave-inf.el" . "octave.el")
    ("octave-mod.el" . "octave.el")
    ("progmodes/octave-inf.el" . "octave.el")
    ("progmodes/octave-mod.el" . "octave.el")
    ;; Obsolete.
    ("lisp/gs.el" . "gs.el")
    ("emacs-lisp/assoc.el" . "assoc.el")
    ("emacs-lisp/cust-print.el" . "cust-print.el")
    ("emacs-lisp/gulp.el" . "gulp.el")
    ("abbrevlist.el" . "abbrevlist.el")
    ("emulation/crisp.el" . "crisp.el")
    ("emulation/tpu-edt.el" . "tpu-edt.el")
    ("emulation/tpu-extras.el" . "tpu-extras.el")
    ("emulation/tpu-mapper.el" . "tpu-mapper.el")
    ("emulation/vi.el" . "vi.el")
    ("emulation/vip.el" . "vip.el")
    ("emulation/ws-mode.el" . "ws-mode.el")
    ("mail/mailpost.el" . "mailpost.el")
    ("net/eudcb-ph.el" . "eudcb-ph.el")
    ("play/bruce.el" . "bruce.el")
    ("play/landmark.el" . "landmark.el")
    ("lisp/play/landmark.el" . "landmark.el")
    ("play/yow.el" . "yow.el")
    ("patcomp.el" . "patcomp.el")
    ("emulation/ws-mode.el" . "ws-mode.el")
    ("vc/vc-arch.el" . "vc-arch.el")
    ("lisp/gnus/messcompat.el" . "messcompat.el")
    ("html2text.el" . "html2text.el")
    ("lisp/net/html2text.el" . "html2text.el")
    ;; Obsolete in 28.1.
    ("inversion.el" . "inversion.el")
    ("test/lisp/cedet/inversion-tests.el" . "inversion-tests.el")
    ("test/lisp/mail/rfc2368-tests.el" . "rfc2368-tests.el")
    ;; This file was briefly obsolete:
    ("lisp/obsolete/erc-compat.el" . "erc-compat.el")
    ;; From lisp to etc/forms.
    ("forms-d2.el" . "forms-d2.el")
    ("forms-pass.el" . "forms-pass.el")
    ;; From lisp/ to etc/nxml.
    ("nxml/test.invalid.xml" . "test-invalid.xml")
    ("nxml/test.valid.xml" . "test-valid.xml")
    ("automated/Makefile.in" . "test/Makefile.in")
    ;; rmailmm tests wandered from test/ to test/manual to test/lisp/mail/
    ("rmailmm.el" . "rmailmm-tests.el")
    ("test/rmailmm.el" . "rmailmm-tests.el")
    ("test/manual/rmailmm.el" . "rmailmm-tests.el")
    ;; The one in lisp is eshell/eshell.el.
    ("eshell.el" . "eshell-tests.el")
    ("automated/eshell.el" . "eshell-tests.el")
    ("eshell/esh-test.el" . "eshell-tests.el")
    ("automated/cl-lib.el" . "cl-lib-tests.el")
    ("automated/cl-lib-tests.el" . "cl-lib-tests.el")
    ("automated/package-x-test.el" . "package-tests.el")
    ("automated/package-test.el" . "package-tests.el")
    ("indent/js-indent-first-initialiser-t.js" . "indent/js-indent-init-t.js")
    ("indent/js-indent-first-initialiser-dynamic.js" .
     "indent/js-indent-init-dynamic.js")
    ;; INSTALL-CVS -> .CVS -> .BZR -> .REPO
    ("INSTALL-CVS" . "INSTALL.REPO")
    ("INSTALL.CVS" . "INSTALL.REPO")
    ("INSTALL.BZR" . "INSTALL.REPO")
    ("gnus-logo.eps" . "gnus-logo.eps")	; moved to refcards/
    ("build-install" . "build-ins.in")
    ("build-install.in" . "build-ins.in")
    ("unidata/Makefile" . "unidata/Makefile.in")
    ("mac/uvs.el" . "unidata/uvs.el")
    ;; Moved from top to etc/
    ("CONTRIBUTE" . "CONTRIBUTE")
    ("FTP" . "FTP")
    ;; Moved from top to build-aux/
    ("move-if-change" . "move-if-change")
    ("update-subdirs" . "update-subdirs")
    ("emacs.tex" . "emacs.texi")
    ("faq.texi" . "efaq.texi")
    ("major.texi" . "modes.texi")
    ("msdog-xtra.texi" . "msdos-xtra.texi")
    ("msdog.texi" . "msdos.texi")
    ;; Moved from lisp/gnus/ to lisp/
    ("auth-source.el" . "auth-source.el")
    ("lisp/gnus/auth-source.el" . "auth-source.el")
    ("ecomplete.el" . "ecomplete.el")
    ("format-spec.el" . "format-spec.el")
    ("gnus/format-spec.el" . "format-spec.el")
    ("lisp/gnus/ecomplete.el" . "ecomplete.el")
    ("plstore.el" . "plstore.el")
    ("lisp/gnus/plstore.el" . "plstore.el")
    ("registry.el" . "registry.el")
    ("lisp/gnus/registry.el" . "registry.el")
    ("rtree.el" . "rtree.el")
    ;; Moved from lisp/gnus/ to lisp/calendar/
    ("time-date.el" . "time-date.el")
    ;; Moved from lisp/gnus/ to lisp/mail/
    ("binhex.el" . "binhex.el")
    ("gnus/binhex.el" . "binhex.el")
    ("uudecode.el" . "uudecode.el")
    ("gnus/uudecode.el" . "uudecode.el")
    ("mail-parse.el" . "mail-parse.el")
    ("gnus/mail-parse.el" . "mail-parse.el")
    ("mail-prsvr.el" . "mail-prsvr.el")
    ("gnus/mail-prsvr.el" . "mail-prsvr.el")
    ("yenc.el" . "yenc.el")
    ("flow-fill.el" . "flow-fill.el")
    ("gnus/flow-fill.el" . "flow-fill.el")
    ("ietf-drums.el" . "ietf-drums.el")
    ("gnus/ietf-drums.el" . "ietf-drums.el")
    ("pop3.el" . "pop3.el")
    ("mail/pop3.el" . "pop3.el")
    ("gnus/pop3.el" . "pop3.el")
    ("lisp/gnus/pop3.el" . "pop3.el")
    ("qp.el" . "qp.el")
    ("gnus/qp.el" . "qp.el")
    ("lisp/gnus/qp.el" . "qp.el")
    ("rfc2045.el" . "rfc2045.el")
    ("gnus/rfc2045.el" . "rfc2045.el")
    ("rfc2047.el" . "rfc2047.el")
    ("gnus/rfc2047.el" . "rfc2047.el")
    ("rfc2231.el" . "rfc2231.el")
    ("gnus/rfc2231.el" . "rfc2231.el")
    ("lisp/gnus/rfc2231.el" . "rfc2231.el")
    ;; Moved from lisp/gnus/ to lisp/image/
    ("compface.el" . "compface.el")
    ("gravatar.el" . "gravatar.el")
    ("lisp/gnus/gravatar.el" . "gravatar.el")
    ;; Moved from lisp/gnus/ to lisp/net/
    ("eww.el" . "eww.el")
    ("net/eww.el" . "eww.el")
    ("lisp/new/eww.el" . "eww.el") ; an actual typo in ChangeLog.3
    ("gssapi.el" . "gssapi.el")
    ("lisp/gnus/gssapi.el" . "gssapi.el")
    ("imap.el" . "net/imap.el")
    ("mailcap.el" . "mailcap.el")
    ("gnus/mailcap.el" . "mailcap.el")
    ("lisp/gnus/mailcap.el" . "mailcap.el")
    ("rfc2104.el" . "net/rfc2104.el")
    ("starttls.el" . "starttls.el")
    ("lisp/net/starttls.el" . "starttls.el") ; moved to obsolete/
    ("shr.el" . "shr.el")
    ("net/shr.el" . "shr.el")
    ("shr-color.el" . "shr-color.el")
    ("sieve-manage.el" . "sieve-manage.el")
    ("sieve-mode.el" . "sieve-mode.el")
    ("sieve.el" . "sieve.el")
    ("lisp/gnus/sieve-manage.el" . "sieve-manage.el")
    ("lisp/gnus/sieve-mode.el" . "sieve-mode.el")
    ("lisp/gnus/sieve.el" . "sieve.el")
    ;;  Moved from lisp/gnus/ to lisp/international
    ("rfc1843.el" . "rfc1843.el")
    ("gnus/rfc1843.el" . "rfc1843.el")
    ("utf7.el" . "utf7.el")
    ("gnus/utf7.el" . "utf7.el")
    ;; And from emacs/ to misc/ and back again.
    ("ns-emacs.texi" . "macos.texi")
    ("overrides.texi" . "gnus-overrides.texi")
    ("xresmini.texi" . "xresources.texi")
    ;; Not renamed, but we only have the latter in the Emacs repo.
    ("trampver.texi.in" . "trampver.texi")
    ;; Renamed with same directory.
    ("e/eterm" . "eterm-color")
    ("e/eterm.ti" . "eterm-color.ti")
    ("README.txt" . "README")
    ("emacs.names" . "JOKES")
    ("ED.WORSHIP" . "JOKES")
    ("GNU.JOKES" . "JOKES")
    ("CHARACTERS" . "TODO")
    ("lisp/character-fold.el" . "char-fold.el")
    ("test/automated/character-fold-tests.el" . "char-fold-tests.el")
    ("test/automated/char-fold-tests.el" . "char-fold-tests.el")
    ("test/lisp/character-fold-tests.el" . "char-fold-tests.el")
    ("test/manual/cycle-tests.el" . "fns-tests.el")
    ("test/manual/cyclic-tests.el" . "fns-tests.el")
    ("test/lisp/dns-mode-tests.el" . "dns-mode-tests.el")
    ("test/lisp/legacy/core-elisp-tests.el" . "lisp-tests.el")
    ("test/lisp/legacy/decoder-test.el" . "coding-tests.el")
    ("test/lisp/legacy/files-tests.el" . "files-tests.el")
    ("test/lisp/legacy/font-parse-tests.el" . "font-tests.el")
    ("test/lisp/legacy/lexbind-tests.el" . "bytecomp-test.el")
    ("test/lisp/legacy/occur-tests.el" . "replace-tests.el")
    ("test/lisp/legacy/syntax-tests.el" . "syntax-tests.el")
    ("test/file-organisation.org" . "file-organization.org")
    ("images/gnus/mail_send.xpm" . "mail-send.xpm") ; still in images/gnus
    ("schema/xhtml-basic-form.rnc" . "xhtml-bform.rnc" )
    ("schema/xhtml-basic-table.rnc" . "xhtml-btable.rnc")
    ("schema/xhtml-list.rnc" . "xhtml-lst.rnc")
    ("schema/xhtml-target.rnc" . "xhtml-tgt.rnc")
    ("schema/xhtml-style.rnc" . "xhtml-xstyle.rnc")
    ("schema/docbook-dyntbl.rnc" . "docbk-dyntbl.rnc")
    ("schema/docbook-soextbl.rnc" . "docbk-soextbl.rn" )
    ("edt-user.doc" . "edt.texi")
    ("DEV-NOTES" . "nextstep")
    ("org/COPYRIGHT-AND-LICENSE" . "org/README")
    ("lisp/net/idna.el" . "puny.el")
    ;; Moved to different directories.
    ("ctags.1" . "ctags.1")
    ("etags.1" . "etags.1")
    ("emacs.1" . "emacs.1")
    ("emacsclient.1" . "emacsclient.1")
    ("icons/emacs21.ico" . "emacs21.ico")
    ("ja-dic" . "leim/ja-dic")
    ("quail" . "leim/quail")
    ("admin/notes/triage" . "bug-triage")
    ;; Moved from autogen/ to admin/.
    ("autogen/update_autogen" . "update_autogen")
    ;; Moved from etc/ to admin/.
    ("grammars" . "grammars")
    ;; Moved from lisp/emacs-lisp/ to admin/.
    ("emacs-lisp/authors.el" . "authors.el")
    ("find-gc.el" . "find-gc.el")
    ("emacs-lisp/find-gc.el" . "find-gc.el")
    ;; From etc to lisp/cedet/semantic/.
    ("grammars/bovine-grammar.el" . "bovine/grammar.el")
    ("grammars/wisent-grammar.el" . "wisent/grammar.el")
    ;; Moved from admin/nt/ to nt/.
    ("nt/README.W32" . "README.W32")
    ("notes/BRANCH" . "notes/repo")
    ("notes/bzr" . "notes/repo")
    ;; moved from lisp/ to lisp/net/, then removed
    ("pinentry.el" . "pinentry.el")
    ("lisp/pinentry.el" . "pinentry.el")
    ("lisp/net/pinentry.el" . "pinentry.el")
    ;; module.* moved to emacs-module.*
    ("src/module.h" . "emacs-module.h")
    ("src/module.c" . "emacs-module.c")
    ("test/src/regex-tests.el" . "regex-emacs-tests.el")
    ("test/lisp/emacs-lisp/cl-tests.el" . "cl-tests.el")
    ("url-ns.el" . "url-ns.el")
    ("gnus-news.texi" . "gnus.texi")
    ("doc/misc/gnus-news.texi" . "gnus.texi")
    ("lisp/multifile.el" . "fileloop.el")
    ("lisp/emacs-lisp/thread.el" . "thread.el")
    ;; cl.el was retired, replaced by cl-lib.el, and we want to
    ;; pretend they are the same file...
    ("emacs-lisp/cl.el" . "cl-lib.el")
    ("lisp/emacs-lisp/cl.el" . "cl-lib.el")
    ("lisp/obsolete/cl.el" . "cl-lib.el")
    ("mantemp.el" . "mantemp.el")
    ("lisp/progmodes/mantemp.el" . "mantemp.el")
    ("progmodes/mantemp.el" . "mantemp.el")
    ("sysdep.c" . "src/sysdep.c")
    ;; nnir.el started in lisp/gnus/ChangeLog.*, then was
    ;; lisp/gnus/nnir.el in ChangeLog.[123], and is now
    ;; lisp/obsolete/nnir.el.
    ("nnir.el" . "nnir.el")
    ("lisp/gnus/nnir.el" . "nnir.el")
    ;; regex.[ch] are mentioned as src/regex.[ch] in ChangeLog.[123],
    ;; but as just regex.[ch] in src/ChangeLog.*, so we need 2 entries
    ;; for each one of them.
    ("regex.c" . "regex-emacs.c")
    ("regex.h" . "regex-emacs.h")
    ("src/regex.c" . "regex-emacs.c")
    ("src/regex.h" . "regex-emacs.h")
    ("test/manual/rmailmm.el" . "rmailmm-tests.el")
    ("test/lisp/cedet/semantic-utest-fmt.el" . "format-tests.el")
    ("test/lisp/emacs-lisp/tabulated-list-test.el" . "tabulated-list-tests.el")
    ("test/lisp/url/url-handlers-test.el" . "url-handlers-tests.el")
    ("test/src/dired-tests.el" . "dired-tests.el")
    (".dir-locals.el" . ".dir-locals.el")
    ;; use-package files that were moved when use-package was added:
    ("use-package.texi" . "use-package.texi")
    ("use-package-core.el" . "use-package-core.el")
    ("bind-key.el" . "use-package-bind-key.el")
    ("use-package.el" . "use-package.el")
    ("use-package-tests.el" . "use-package-tests.el")
    ;; pgtk stuff which used incorrect file names
    ("pgtkmenu.c" . "pgtkmenu.c")
    ("pgtk-win.el" . "pgtk-win.el")
    ("pgtkfns.c" . "pgtkfns.c")
    ("pgtkterm.c" . "pgtkterm.c")
    ("pgtkterm.h" . "pgtkterm.h")
    ("../src/pgtkfns.c" . "pgtkfns.c")
    ("../src/pgtkterm.c" . "pgtkterm.c")
    ("../src/pgtkterm.h" . "pgtkterm.h")
    ("../src/atimer.c" . "atimer.c")
    ("../src/gtkutil.c" . "gtkutil.c")
    ("../src/image.c" . "image.c")
    ("../lisp/faces.el" . "faces.el")
    ("../src/pgkterm.h" . "pgkterm.h")
    ("pgkterm.c" . "pgkterm.c")
    ("../src/emacsgtkfixed.c" . "emacsgtkfixed.c")
    ("../src/xfaces.c" . "xfaces.c")
    ("../src/pgtkgui.h" . "pgtkgui.h")
    ("../src/dispextern.h" . "dispextern.h")
    ("../src/menu.c" . "menu.c")
    ("../lisp/net/browse-url.el" . "browse-url.el")
    ;; miscellany
    ("nsterm.m" . "nsterm.m")
    ("jsonrpc.el" . "jsonrpc.el")
    ("jsonrpc-tests.el" . "jsonrpc-tests.el")
    ("jrpc.el" . "jsonrpc.el")
    ("eldoc.el" . "eldoc.el")
    ("lisp/progmodes/ts-mode.el" . "typescript-ts-mode.el")
    ("icalendar-tests.el" . "icalendar-tests.el")
    ("lisp/progmodes/css-ts-mode.el" . "css-mode.el")
    ("lisp/erc/erc-tests.el" . "erc-tests.el")
    ("lisp/erc/erc-scenarios-base-reconnect.el" . "erc-scenarios-base-reconnect.el")
    ("test/lisp/erc-tests.el" . "erc-tests.el")
    ("eglot.el" . "eglot.el")
    ("eglot-tests.el" . "eglot-tests.el")
    ("NEWS.md" . "EGLOT-NEWS")
    ("test/lisp/comp-tests.el" . "comp-tests.el")
    ("package-vc.el" . "package-vc.el")
    ("package.el" . "package.el")
    ("lisp/net/tramp-docker.el" . "tramp-container.el")
    ("xterm.c" . "xterm.c")
    ("lisp/osc.el" . "ansi-osc.el")
    ("test/lisp/osc-tests.el" . "ansi-osc-tests.el")
    ("lisp/ansi-osc.el" . "ansi-osc-tests.el")
    ("test/lisp/thumbs-tests.el" . "thumbs-tests.el")
    ("rmail.el" . "rmail.el")
    ("window.el" . "window.el")
    ("nsmenu.m" . "nsmenu.m")
    ("nsfont.m" . "nsfont.m")
    ("nsfns.m" . "nsfns.m")
    ("src/nsterm.c" . "nsterm.m")
    ("subr.el" . "subr.el")
    ("test/lisp/image-dired-tests.el" . "image-dired-tests.el")
    ("modus-themes.org" . "modus-themes.org")
    ("emacs-authors-mode.el" . "emacs-authors-mode.el")
    ("lisp/textmodes/etc-authors-mode.el" . "emacs-authors-mode.el")
    ("bytecomp.el" . "bytecomp.el")
    ("test/lisp/makesum-tests.el" . "makesum-tests.el")
    ("rcirc.el" . "rcirc.el")
    ("haiku_support.cc" . "haiku_support.cc")
    ("gnus-art.el" . "gnus-art.el")
    ("mh-mime.el" . "mh-mime.el")
    ("terminal.c" . "terminal.c")
    ("eudc.texi" . "eudc.texi")
    ("gnus-search.el" . "gnus-search.el")
    ("lisp/gnus-search.el" . "gnus-search.el")
    ("ETAGS_good_1" . "ETAGS_good_1")
    ("ETAGS_good_2" . "ETAGS_good_2")
    ("ETAGS_good_3" . "ETAGS_good_3")
    ("ETAGS_good_4" . "ETAGS_good_4")
    ("ETAGS_good_5" . "ETAGS_good_5")
    ("ETAGS_good_6" . "ETAGS_good_6")
    ("test/lisp/eshell-em-script-tests.el" . "eshell-em-script-tests.el")
    ("test/lisp/eshell-em-glob-tests.el" . "eshell-em-glob-tests.el")
    ("lisp/eshell/esh-var-tests.el" . "esh-var-tests.el")
    ("test/lisp/eshell/esh-var-test.el" . "esh-var-tests.el")
    ("gnus-logic.el" . "gnus-logic.el")
    ("sh-script.el" . "sh-script.el")
    ("repeat.el" . "repeat.el")
    ("files.el" . "files.el")
    ("lisp/emacs-lisp/generate-file.el" . "generate-lisp-file.el")
    ("pp.el" . "pp.el")
    ("src/help-fns.el" . "help-fns.el")
    ("print.c" . "print.c")
    ("shell.el" . "shell.el")
    ("xdisp.c" . "xdisp.c")
    ("haikufns.c" . "haikufns.c")
    ("haikuterm.c" . "haikuterm.c")
    ("haikumenu.c" . "haikumenu.c")
    ("haikufont.c" . "haikufont.c")
    ("src/haiku_support.c" . "haiku_support.cc")
    ("src/haiku_draw_support.c" . "haiku_draw_support.cc")
    ("haiku-win.el" . "haiku-win.el")
    ("elisp-mode.el" . "elisp-mode.el")
    ("doc-view.el" . "doc-view.el")
    ("src/lisp/net/rcirc.el" . "rcirc.el")
    ("project.el" . "project.el")
    ("emacsbug.el" . "emacsbug.el")
    ("timefns.c" . "timefns.c")
    ("xwidget.c" . "xwidget.c")
    ("src/xwidget.el" . "xwidget.el")
    ("lisp/net/lisp/net/tramp-sshfs.el" . "tramp-sshfs.el")
    ("tramp-sudoedit.el" . "tramp-sudoedit.el")
    ("test/lisp/mail/undigest.el" . "undigest-tests.el")
    ("Activate.c" . "Activate.c")
    ("quail.el" . "quail.el")
    ("sed1v2.inp" . "sed1v2.inp")
    ("ruby-parenless-call-arguments-indent.rb" . "ruby-parenless-call-arguments-indent.rb")
    ("commands.texi" . "doc/lispref/commands.texi")
    ("message.el" . "message.el")
    ("lisp/debug-early.el" . "debug-early.el")
    ("tabulated-list.el" . "tabulated-list.el")
    ("mouse.el" . "mouse.el")
    ("hi-lock.el" . "hi-lock.el")
    ("man.el" . "man.el")
    ("doc/emacs/frames.tex" . "frames.texi")
    ("lisp/emacs-list/eieio-compat.el" . "eieio-compat.el")
    ("epa.el" . "epa.el")
    ("lisp/emacs-lisp/macroexpand.el" . "macroexp.el")
    ("src/pixel-scroll.el" . "pixel-scroll.el")
    ("test/lisp/mh-e/mh-utils.el" . "mh-utils-tests.el")
    ("compile.el" . "compile.el")
    ("compile-tests.el" . "compile-tests.el")
    ("Makefile.in" . "Makefile.in")
    ("Makefie.in" . "Makefile.in")
    ("test/lisp/net/netrc-tests.el" . "auth-source-tests.el")
    ("test/lisp/ert-x-tests.el" . "ert-x-tests.el")
    ("lisp/mh-e-mh-scan.el" . "mh-scan.el")
    ("lisp/progmodes/c-fonts.el" . "cc-fonts.el")
    ("lisp/emacs/lisp/cl-generic.el" . "cl-generic.el")
    ("doc/lisprefdisplay.texi" . "display.texi")
    ("erc.el" . "erc.el")
    ("erc-tests.el" . "erc-tests.el")
    ("vc/vc-mtn.el" . "vc-mtn.el")
    ("net/rlogin.el" . "rlogin.el")
    ("emacs-lisp/eieio-compat.el" . "eieio-compat.el")
    ("mh-compat.el" . "mh-compat.el")
    ("url-about.el" . "url-about.el")
    ("url-dired.el" . "url-dired.el")
    ("lisp/text-modes/tex-mode.el" . "tex-mode.el")
    ("editfns.c" . "editfns.c")
    ("lisp/thumbs.el" . "thumbs.el")
    ("lisp/linum.el" . "linum.el")
    ("lisp/image-dired.el" . "image-dired.el")
    ("lisp/url/url-about.el" . "url-about.el")
    ("lisp/url/url-dired.el" . "url-dired.el")
    ("lisp/ps-def.el" . "ps-def.el")
    ("lisp/net/quickurl.el" . "quickurl.el")
    ("lisp/vc/vc-mtn.el" . "vc-mtn.el")
    ("lisp/mail/uce.el" . "uce.el")
    ("test/lisp/progmodes/csharp-ts-mode-tests.el" . "csharp-mode.el")
    ("lisp/makesum.el" . "makesum.el")
    ("lisp/mh-e/mh-compat.el" . "mh-compat.el")
    ("lisp/net/rlogin.el" . "rlogin.el")
    ("lisp/emacs-lisp/autoload.el" . "autoload.el")
    ("lisp/emacs-lisp/eieio-compat.el" . "eieio-compat.el")
    ("autoarg.el" . "autoarg.el")
    )
  "Alist of files which have been renamed during their lifetime.
Elements are (OLDNAME . NEWNAME).")

;; Should still test that the renamed file exists.  Does it?
;; But it might be relative to a different ChangeLog...
;;
;; Note that only the basename of the RHS is used.
;; Cf authors-renamed-files-alist.
(defconst authors-renamed-files-regexps
  '(("\\`\\(arg-nonnull\\|c\\+\\+defs\\|warn-on-use\\)\\.h\\'"
     "lib/\\&")
    ("\\`\\(ebuild\\|emacs\\|install\\|fast-install\\)\\.cmd\\'" "\\1.bat")
    ("\\`\\(book-spine\\|cl\\|forms\\|functions\\|gnus\\|sc\\|texinfo\\|vip\\)\
\\.texinfo\\'" "\\1.texi")
    ("\\`\\(\\(calc\\|org\\|vip\\)card\\|viperCard\\|\
\\(\\(cs\\|fr\\|sk\\)-\\)?dired-ref\\|\
\\(\\(cs\\|de\\|fr\\|gnus\\|pl\\|pt-br\\|ru\\|sk\\)-\\)?refcard\\|\
\\(\\(cs\\|fr\\|sk\\)-\\)?survival\\)\\.tex\\'" "refcards/\\&")
    ("\\`refcard-\\(de\\|pl\\)\\.tex\\'" "refcards/\\1-refcard.tex")
    ("\\`\\(refcards/\\)?fr-drdref\\.tex\\'" "refcards/fr-dired-ref.tex")
    ("\\`\\(TUTORIAL[^/]*\\)" "tutorials/\\1")
    ("\\`themes/dev-\\(tsdh-\\(?:light\\|dark\\)-theme\\.el\\)\\'"
     "themes/\\1")
    ;; Moved from lisp/toolbar to etc/images.
    ("\\`toolbar/\\(back\\|fwd\\|left\\|right\\|up\\)_arrow\
\\(\\.\\(?:pb\\|xp\\)m\\)\\'" "images/\\1-arrow\\2")
    ("\\`toolbar/lc-\\(back\\|fwd\\|left\\|right\\|up\\)_arrow\
\\(\\.\\(?:pb\\|xp\\)m\\)\\'" "images/low-color/\\1-arrow\\2")
    ("\\`toolbar/mail_\\(compose\\|send\\)\\(\\.[xp]bm\\)\\'"
     "images/mail/\\1")
    ("\\`toolbar/jump_to\\(\\.\\(?:pb\\|xp\\)m\\)\\'" "images/jump-to\\1")
    ("\\`toolbar/lc-jump_to\\(\\.\\(?:pb\\|xp\\)m\\)\\'"
     "images/low-color/jump-to\\1")
    ("\\`toolbar/\\(attach\\|cancel\\|close\\|copy\\|cut\\|\
diropen\\|exit\\|help\\|home\\|index\\|info\\|mail\\|new\\|open\\|\
paste\\|preferences\\|print\\|save\\|saveas\\|search\\|search-replace\\|\
spell\\|undo\\)\\(\\.\\(?:pb\\|xp\\)m\\)\\'" "images/\\1\\2")
    ("\\`toolbar/gud-\\(break\\|cont\\|down\\|finish\\|print\\|pstar\\|\
remove\\|run\\|until\\|up\\|watch\\)\\(\\.\\(?:pb\\|xp\\)m\\)\\'"
     "images/gud/\\1\\2")
    ("\\`\\(toolbar/gud-\\|images/gud/\\)n\\(i\\)?\\(\\.\\(?:pb\\|xp\\)m\\)\\'"
     "images/gud/next\\2\\3")
    ("\\`\\(toolbar/gud-\\|images/gud/\\)s\\(i\\)?\\(\\.\\(?:pb\\|xp\\)m\\)\\'"
     "images/gud/step\\2\\3")
    ("\\`toolbar/lc-\\([-a-z]+\\.xpm\\)\\'" "images/low-color/\\1")
    ("\\`\\(tree-widget/\\(?:default\\|folder\\)/[-a-z]+\\.\\(png\\|xpm\\)\\)\\'"
     "images/\\1")
    ("\\`\\(images/icons/\\)mac\\(emacs\\)_\\([0-9]+\\)\\(\\.png\\)"
     "\\1\\2\\3_mac\\4")
    ("\\(images/icons/\\)emacs_\\([0-9][0-9]\\)\\.png"
     "\\1hicolor/\\2x\\2/apps/emacs.png")
    ;; Moved from leim/ to lisp/leim/.
    ("\\`quail/[-a-z0-9]+\\.el\\'" "leim/\\&")
    ("\\`ja-dic/ja-dic\\.el\\'" "leim/\\&")
    ("\\`vc-\\(rcs\\|cvs\\|sccs\\)-hooks\\.el\\'" "vc/vc-\\1.el")
    ("\\`vc-\\(annotate\\|arch\\|bzr\\|cvs\\|dav\\|dir\\|dispatcher\\|\
git\\|hg\\|hooks\\|mtn\\|rcs\\|sccs\\|svn\\)\\.el\\'" "vc/\\&")
    ("\\`ediff-\\(diff\\|help\\|hook\\|init\\|merg\\|mult\\|ptch\\|util\\|\
vers\\|wind\\)\\.el\\'" "vc/\\&")
    ("\\`pcvs-\\(defs\\|info\\|parse\\|util\\)\\.el\\'" "vc/\\&")
    ("\\`\\(add-log\\|compare-w\\|cvs-status\\|diff-mode\\|diff\\|\
ediff\\|emerge\\|log-edit\\|log-view\\|pcvs\\|smerge-mode\\|vc\\)\\.el\\'"
     "vc/\\&")
    ("\\`\\(emacs-lisp/\\)?helpers\\.el\\'" "emacs-lisp/subr-x.el")
    ;; I assume this is (essentially) what happened, org/ChangeLog is vague.
    ("\\`org-\\(ascii\\|beamer\\|html\\|icalendar\\|jsinfo\\|latex\
\\|odt\\|publish\\)\\.el\\'" "ox-\\1.el")
    ;; From test/ to test/automated/.
    ("comint-testsuite\\.el" "automated/\\&")
    ("\\`\\(bytecomp\\|font-parse\\|icalendar\\|occur\\|newsticker\\)\
-testsuite\\.el" "\\1-tests.el")
    ("automated/flymake/warnpred/\\(Makefile\\|test\\.\\(?:c\\|pl\\)\\)\\'"
     "automated/data/flymake/\\1")
    ;; More complicated than this, but we only use the basename of the RHS.
    ("automated/\\([^/]*-test[^/]*\\.el\\)\\'" "\\1")
    ;; Maybe not the exact new name, but disambiguates from lisp/.
    ("automated/\\([^/]*\\)\\.el\\'" "\\1-tests.el")
    ;; NB lax rules should come last.
    ("\\`m/m-\\(.*\\.h\\)\\'" "m/\\1" t)
    ("\\`m-\\(.*\\.h\\)\\'" "\\1" t)
    ("\\`s/s-\\(.*\\.h\\)\\'" "s/\\1" t)
    ("\\`s-\\(.*\\.h\\)\\'" "\\1" t)
    ("\\.\\(el\\|[ch]\\|x[pb]m\\|pbm\\)\\'" t t)
    )
  "List of regexps and rewriting rules for renamed files.
Elements are (REGEXP REPLACE [LAX]).  If REPLACE is a string, the file
name matching REGEXP is replaced by REPLACE using `replace-string'.
Otherwise, the file name is accepted as is.
Elements with LAX non-nil are only used in `authors-lax-changelogs'.")

;; It's really not worth trying to make these old logs fully valid.
;; All the obvious real errors are gone.
;; The main issue is _lots_ of moving around of files.
;; Eg the progmodes/ (etc) directories did not exist before 1997.
;; Also, lib-src/ did not exist, the files were in etc/.
;; And various other things.
(defconst authors-lax-changelogs
  '("erc/ChangeLog\\.1\\'"
    "gnus/ChangeLog\\.[1-2]\\'"
    "lisp/ChangeLog\\.\\([1-9]\\|1[0-5]\\)\\'"
    "mh-e/ChangeLog\\.1\\'"
    "src/ChangeLog\\.\\([1-9]\\|1[0-2]\\)\\'")
  "List of regexps matching ChangeLogs that we do not print errors from.
These are older ChangeLogs that have various issues.
Additionally, for these logs we apply the `lax' elements of
`authors-renamed-files-regexps'.")


(defvar authors-checked-files-alist)
(defvar authors-invalid-file-names)
(defvar authors-ignored-names)

;; This has become rather yucky. :(
(defun authors-disambiguate-file-name (fullname)
  "Convert FULLNAME to an unambiguous relative-name."
  (let ((relname (file-name-nondirectory fullname))
	dir)
    (if (and (member relname authors-ambiguous-files)
	     ;; Try to identify the top-level directory.
	     ;; FIXME should really use ROOT from M-x authors.
	     (not (and (file-directory-p
			(expand-file-name
			 "lib-src"
			 (setq dir (file-name-directory fullname))))
		       (file-directory-p (expand-file-name "etc" dir)))))
	;; I think it looks weird to see eg "lisp/simple.el".
	;; But for eg Makefile.in, we do want to say "lisp/Makefile.in".
	(if (and (string-equal "lisp"
			       (file-name-nondirectory
				(directory-file-name dir)))
		 ;; TODO better to simply have hard-coded list?
		 ;; Only really Makefile.in where this applies.
		 (not (file-exists-p
		       (expand-file-name (concat "../" relname) dir))))
	    relname
	  ;; In case of ambiguity, just prepend the parent directory.
	  ;; FIXME obviously this is not a perfect solution.
	  (format "%s/%s" (file-name-nondirectory (directory-file-name dir))
		  relname))
      relname)))

(defun authors-lax-changelog-p (file)
  "Return non-nil if FILE matches `authors-lax-changelogs'."
  (let ((list authors-lax-changelogs)
	found)
    (while list
      (setq list (if (setq found (string-match-p (car list) file))
		     nil
		   (cdr list))))
    found))

(defun authors-canonical-file-name (file log-file pos author)
  "Return canonical file name for FILE found in LOG-FILE.
FILE is the file name as it appears in LOG-FILE, including any
leading directories mentioned there.
LOG-FILE is an absolute file name of the log file we are scanning.
Checks whether FILE is a valid (existing) file name, has been renamed,
or is on the list of removed files.  Returns the non-directory part of
the file name to use for FILE in the \"AUTHORS\" file.
Only uses the LOG-FILE position POS and associated AUTHOR to print a
message if FILE is not found."
  ;; FILE should be re-checked in every different directory associated
  ;; with a LOG-FILE.  Eg configure.ac from src/ChangeLog is not the
  ;; same as that from top-level/ChangeLog.
  (let* ((fullname (expand-file-name file (file-name-directory log-file)))
	 (entry (assoc fullname authors-checked-files-alist))
	 laxlog relname valid)
    (if entry
	(cdr entry)
      (setq relname (file-name-nondirectory file))
      ;; File names in `authors-valid-file-names' are OK by
      ;; definition, so no need to check those.
      (if (or (member file authors-valid-file-names)
	      (member relname authors-valid-file-names)
	      (file-exists-p file)
	      (file-exists-p relname)	; FIXME? appropriate?
	      )
	  (setq valid (authors-disambiguate-file-name fullname))
	(if (setq valid (assoc file authors-renamed-files-alist))
	    (setq valid (cdr valid))
	  (setq laxlog (authors-lax-changelog-p log-file))
	  (let ((rules authors-renamed-files-regexps)
		rule)
	    (while rules
	      (setq rule (car rules))
	      (if (and (or laxlog (not (nth 2 rule)))
		       (string-match (car rule) file))
		  (setq valid (if (stringp (nth 1 rule))
				  (file-name-nondirectory
				   (replace-match (nth 1 rule) t nil file))
				relname)
			rules nil)
		(setq rules (cdr rules)))))))
      (setq authors-checked-files-alist
	    (cons (cons fullname valid) authors-checked-files-alist))
      (unless (or valid
		  (member file authors-ignored-files)
		  (authors-obsolete-file-p file)
		  (string-search "*" file)
		  (string-match "^[0-9.]+$" file)
		  laxlog)
	(setq authors-invalid-file-names
	      (cons (format-message "%s:%d: unrecognized `%s' for %s"
				    log-file
				    (1+ (count-lines (point-min) pos))
				    file author)
		    authors-invalid-file-names)))
      valid)))

(defun authors-add-fixed-entries (table)
  "Add actions from `authors-fixed-entries' to TABLE."
  (dolist (entry authors-fixed-entries)
    (let ((author (car entry))
	  action)
      (dolist (item (cdr entry))
	(if (symbolp item)
	    (setq action item)
	  (authors-add author item action table))))))


(defun authors-obsolete-file-p (file)
  "Return non-nil if FILE is obsolete.
FILE is considered obsolete if it matches one of the regular expressions
from `authors-obsolete-files-regexps'."
  (let (obsolete-p
	(regexps authors-obsolete-files-regexps))
    (while (and regexps (not obsolete-p))
      (setq obsolete-p (string-match (car regexps) file)
	    regexps (cdr regexps)))
    obsolete-p))

(defun authors-no-scan-file-p (file)
  "Return non-nil if FILE should not be scanned.
FILE is not scanned if it matches any of `authors-no-scan-regexps'."
  (let (no-scan-p
	(regexps authors-no-scan-regexps))
    (while (and regexps (not no-scan-p))
      (setq no-scan-p (string-match-p (car regexps) file)
	    regexps (cdr regexps)))
    no-scan-p))

(defun authors-add (author file action table)
  "Record that AUTHOR worked on FILE.
ACTION is a keyword symbol describing what he did.  Record file,
author and what he did in hash table TABLE.  See the description of
`authors-scan-change-log' for the structure of the hash table."
  (unless (or (member file authors-ignored-files)
	      (authors-obsolete-file-p file)
	      (equal author ""))
    (let* ((value (gethash author table))
	   (entry (assoc file value))
	   slot)
      (if (null entry)
	  (puthash author (cons (list file (cons action 1)) value) table)
	(if (setq slot (assoc action (cdr entry)))
	    (setcdr slot (1+ (cdr slot)))
	  (nconc entry (list (cons action 1))))))))


(defun authors-canonical-author-name (author file pos)
  "Return a canonicalized form of AUTHOR, an author name.
If AUTHOR has an entry in `authors-aliases', use that.  Remove
email addresses.  Capitalize words in the author's name, unless
it is found in `authors-fixed-case'."
  (let* ((aliases authors-aliases)
	 regexps realname)
    (while aliases
      (setq realname (car (car aliases))
	    regexps (cdr (car aliases))
	    aliases (cdr aliases))
      (while regexps
	(if (string-match (car regexps) author)
	    (setq author realname
		  regexps nil
		  aliases nil)
	  (setq regexps (cdr regexps))))))
  (when author
    (setq author (replace-regexp-in-string "[ \t]*[(<].*$" "" author))
    (setq author (replace-regexp-in-string "\\`[ \t]+" "" author))
    (setq author (replace-regexp-in-string "[ \t]+$" "" author))
    (setq author (replace-regexp-in-string "[ \t]+" " " author))
    ;; NB this ignores the first name only case.
    (unless (string-match "[-, \t]" author)
      (or (authors-lax-changelog-p file)
          (push (format-message "%s:%d: ignored `%s'"
                                file (1+ (count-lines (point-min) pos)) author)
                authors-ignored-names))
      (setq author ""))
    (or (car (member author authors-fixed-case))
	(capitalize author))))

(defun authors-scan-change-log (log-file table)
  "Scan change log LOG-FILE for author information.

For each change mentioned in the log, add an entry to hash table TABLE
under the author's canonical name.

Keys of TABLE are author names.  Values are alists of entries (FILE
\(ACTION . COUNT) ...).  FILE is one file the author worked on.  The
rest of the entry is a list of keyword symbols describing what he did
with the file and the number of each action:

:wrote		means the author wrote the file
:cowrote	means he wrote the file in collaboration with others
:changed	means he changed the file COUNT times."

  (let* ((enable-local-variables :safe)	; for find-file, hence let*
	 (enable-local-eval nil)
	 (existing-buffer (get-file-buffer log-file))
	 (buffer (find-file-noselect log-file))
	 authors pos)
    (with-current-buffer buffer
      (save-restriction
	(widen)
	(goto-char (point-min))
	(while (re-search-forward "^[0-9]\\|^[ \t]+\\* " nil t)
	  (beginning-of-line)
	  (setq pos (point))
	  (cond ((looking-at "^[0-9]+-[0-9]+-[0-9]+")
		 ;; Handle joint authorship of changes.
		 ;; This can be a bit fragile, and is not too common.
		 (setq authors nil)
		 (while (progn
			  (skip-chars-forward " \t+:0-9-")
			  (not (looking-at "\\($\\|\\*\\|\
Suggested\\|Trivial\\|Version\\|Originally\\|From:\\|Patch[ \t]+[Bb]y\\)")))
		   (push (authors-canonical-author-name
			  (buffer-substring-no-properties
			   (point) (line-end-position)) log-file pos) authors)
		   (forward-line 1)))
		((looking-at "^[ \t]+\\*")
		 (let ((line (buffer-substring-no-properties
			      (match-end 0) (line-end-position))))
		   (while (and (not (string-search ":" line))
			       (forward-line 1)
			       (not (looking-at ":\\|^[ \t]*$")))
		     (setq line (concat line
					(buffer-substring-no-properties
					 (line-beginning-position)
					 (line-end-position)))))
		   (when (string-match ":" line)
		     (setq line (substring line 0 (match-beginning 0)))
		     (setq line (replace-regexp-in-string "[[(<{].*$" "" line))
		     (setq line (string-replace "," "" line))
		     (dolist (file (split-string line))
		       (when (setq file (authors-canonical-file-name file log-file pos (car authors)))
			 (dolist (author authors)
			   ;;(message "%s changed %s" author file)
			   (authors-add author file :changed table)))))
		   (forward-line 1)))))))
    (unless existing-buffer
      (kill-buffer buffer))))


(defun authors-scan-el (file table)
  "Scan Lisp file FILE for author information.
TABLE is a hash table to add author information to."
  (let* ((existing-buffer (get-file-buffer file))
	 (enable-local-variables :safe)	; for find-file, hence let*
	 (enable-local-eval nil)
	 (buffer (find-file-noselect file)))
    (setq file (expand-file-name file))
    (with-current-buffer buffer
      (save-restriction
	(widen)
	(goto-char (point-min))
	(while (and (re-search-forward
		     "^;+[ \t]*\\(Authors?\\|Commentary\\|Code\\):[ \t]*" nil t)
		    (not (member (match-string 1) '("Commentary" "Code"))))
	  (let ((continue t)
		(action :wrote)
		authors)
	    (while continue
	      ;; Some entries contain a year range in front of the
	      ;; author's name.
	      (skip-chars-forward "-0-9 \t")
	      (push (authors-canonical-author-name
		     (buffer-substring-no-properties
		      (point) (line-end-position))
		     file (line-beginning-position)) authors)
	      ;; tips.texi says the continuation line should begin
	      ;; with a tab, but often spaces are used.
	      (setq continue
		    (and (zerop (forward-line 1))
			 (looking-at ";;;?\\(\t+ *\\|  +\\)[[:alnum:]]")
			 (goto-char (1- (match-end 0)))
			 (not (looking-at "[[:upper:]][-[:alpha:]]+:[ \t]")))))
	    (and (> (length authors) 1)
		 (setq action :cowrote))
	    (mapc (lambda (author)
		    (authors-add
		     author
		     (authors-disambiguate-file-name file) action table))
		  authors)))))
    (unless existing-buffer
      (kill-buffer buffer))))


(defun authors-public-domain-p (file)
  "Return t if FILE is a file that was put in public domain."
  (let ((public-domain-p nil)
	(list authors-public-domain-files))
    (while (and list (not public-domain-p))
      (when (string-match (car list) file)
	(setq public-domain-p t))
      (setq list (cdr list)))
    public-domain-p))

(defvar authors-author-list)

(defun authors-add-to-author-list (author changes)
  "Insert information about AUTHOR's work on Emacs into `authors-author-list'.
CHANGES is an alist of entries (FILE (ACTION . COUNT) ...), as produced by
`authors-scan-change-log'.
The element added to `authors-author-list' is (AUTHOR WROTE CO-WROTE CHANGED),
where WROTE, CO-WROTE, and CHANGED are lists of the files written, co-written
and changed by AUTHOR."
  (when author
    (let ((nchanged 0)
	  wrote-list
	  cowrote-list
	  changed-list)
      (dolist (change changes)
	(let* ((actions (cdr change))
	       (file (car change))
	       (filestat (if (authors-public-domain-p file)
			     (concat file " (public domain)")
			   file)))
	  (cond ((assq :wrote actions)
		 (setq wrote-list (cons filestat wrote-list)))
		((assq :cowrote actions)
		 (setq cowrote-list (cons filestat cowrote-list)))
		(t
		 (setq changed-list
		       (cons (cons file (cdr (assq :changed actions)))
			     changed-list))))))
      (if wrote-list
	  (setq wrote-list (sort wrote-list #'string-lessp)))
      (if cowrote-list
	  (setq cowrote-list (sort cowrote-list #'string-lessp)))
      (when changed-list
	(setq changed-list (sort changed-list
				 (lambda (a b)
				   (if (= (cdr a) (cdr b))
				       (string-lessp (car a) (car b))
				     (> (cdr a) (cdr b))))))
	(setq nchanged (length changed-list))
	(setq changed-list (mapcar #'car changed-list)))
      (if (> (- nchanged authors-many-files) 2)
	  (setcdr (nthcdr authors-many-files changed-list)
		  (list (format "and %d other files" (- nchanged authors-many-files)))))
      (setq authors-author-list
	    (cons (list author wrote-list cowrote-list changed-list)
		  authors-author-list)))))

(defun authors (root &optional nologupdate)
  "Extract author information from change logs and Lisp source files.
ROOT is the root directory under which to find the files.
Interactively, read ROOT from the minibuffer.
Accurate author information requires up-to-date change logs, so this
first updates them, unless optional prefix argument NOLOGUPDATE is non-nil.
The result is a buffer *Authors* containing authorship information,
and a buffer *Authors Errors* containing references to unknown files."
  (interactive "DEmacs source directory: \nP")
  (setq root (expand-file-name root))
  (unless (file-exists-p (expand-file-name "src/emacs.c" root))
    (unless (y-or-n-p
             (format "Not the root directory of Emacs: %s, continue? " root))
      (user-error "Not the root directory")))
  ;; May contain your personal entries.
  (or (not (file-exists-p (expand-file-name "ChangeLog" root)))
      (y-or-n-p "Unversioned ChangeLog present, continue?")
      (user-error "Unversioned ChangeLog may have irrelevant entries"))
  (or nologupdate
      ;; There are likely to be things that need fixing, so we update
      ;; the versioned ChangeLog.N rather than the unversioned ChangeLog.
      (zerop (call-process "make" nil nil nil
                           "-C" root "change-history-nocommit"))
      (error (substitute-command-keys
              "Problem updating ChangeLog, try \"\\[universal-argument] \\[authors]\"")))
  (let ((logs (process-lines find-program root "-name" "ChangeLog*"))
	(table (make-hash-table :test 'equal))
	(buffer-name "*Authors*")
	authors-checked-files-alist
	authors-invalid-file-names
	authors-ignored-names)
    (authors-add-fixed-entries table)
    (dolist (log logs)
      (when (string-match "ChangeLog\\(.[0-9]+\\)?$" log)
	(message "Scanning %s..." log)
	(authors-scan-change-log log table)))
    (let ((els (process-lines find-program root "-name" "*.el")))
      (dolist (file els)
	(unless (authors-no-scan-file-p file)
	  (message "Scanning %s..." file)
	  (authors-scan-el file table))))
    (message "Generating buffer %s..." buffer-name)
    (set-buffer (get-buffer-create buffer-name))
    (erase-buffer)
    (set-buffer-file-coding-system authors-coding-system)
    (insert
"Many people have contributed code included in the Free Software
Foundation's distribution of GNU Emacs.  To show our appreciation for
their public spirit, we list here in alphabetical order a condensed
list of their contributions.\n")
    (let (authors-author-list)
      (maphash #'authors-add-to-author-list table)
      (setq authors-author-list
	    (sort authors-author-list
		  (lambda (a b)
		    (string-collate-lessp (car a) (car b)
					  (if (eq system-type 'windows-nt)
					      "enu_USA"
					    "en_US.UTF-8")))))
      (dolist (a authors-author-list)
	(let ((author (car a))
	      (wrote (nth 1 a))
	      (cowrote (nth 2 a))
	      (changed (nth 3 a)))
	(insert "\n" author ": ")
	(when wrote
	  (insert "wrote")
	  (dolist (file wrote)
	    (if (> (+ (current-column) (length file)) 72)
	      (insert "\n "))
	    (insert " " file))
	  (insert "\n"))
	(when cowrote
	  (if wrote
	      (insert "and "))
	  (insert "co-wrote")
	  (dolist (file cowrote)
	    (if (> (+ (current-column) (length file)) 72)
	      (insert "\n "))
	    (insert " " file))
	  (insert "\n"))
	(when changed
	  (if (or wrote cowrote)
	      (insert "and "))
	  (insert "changed")
	  (dolist (file changed)
	    (if (> (+ (current-column) (length file)) 72)
		(insert "\n "))
	    (insert " " file))
	  (insert "\n")))))
    (insert "\nLocal" " Variables:\nmode: emacs-authors\ncoding: "
	    (symbol-name authors-coding-system) "\nEnd:\n")
    (message "Generating buffer %s... done" buffer-name)
    (unless noninteractive
      (when (or authors-invalid-file-names authors-ignored-names)
	(with-current-buffer (get-buffer-create "*Authors Errors*")
	  (setq buffer-read-only nil)
	  (erase-buffer)
	  (set-buffer-file-coding-system authors-coding-system)
	  (when authors-invalid-file-names
	    (insert "Unrecognized file entries found:\n\n")
	    (mapc (lambda (f) (if (not (string-match "^[A-Za-z]+$" f)) (insert f "\n")))
		  (sort authors-invalid-file-names #'string-lessp)))
	  (when authors-ignored-names
	    (insert "\n\nThese authors were ignored:\n\n"
		    (mapconcat
		     #'identity
		     (sort authors-ignored-names #'string-lessp) "\n")))
	  (goto-char (point-min))
	  (compilation-mode)
	  (message "Errors were found.  See buffer %s" (buffer-name))))
      (pop-to-buffer buffer-name))))


(defun batch-update-authors ()
  "Produce an AUTHORS file.
Call this function in batch mode with two command line arguments FILE
and ROOT.  FILE is the file to write, ROOT is the root directory of
the Emacs source tree, from which to build the file."
  (unless noninteractive
    (error "`batch-update-authors' is to be used only with -batch"))
  (when (/= (length command-line-args-left) 2)
    (error "Call `batch-update-authors' with the name of the file to write"))
  (let* ((file (pop command-line-args-left))
	 (root (pop command-line-args-left)))
    (authors root)
    (write-file file)))

(provide 'authors)

;;; authors.el ends here
