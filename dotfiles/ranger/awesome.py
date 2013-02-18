# Copyright (C) 2009, 2010, 2011  Roman Zimbelmann <romanz@lavabit.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Default(ColorScheme):
	def use(self, context):
		fg, bg, attr = default_colors

		if context.reset:
			return default_colors

		elif context.in_browser:
			if context.selected:
				attr = normal
			else:
				attr = normal
			if context.empty or context.error:
				bg = black
			if context.border:
				fg = black
			if context.media:
				if context.image:
					fg = green
				else:
					fg = magenta
			if context.container:
				fg = red
			if context.directory:
				attr |= normal
				fg = blue
			elif context.executable and not \
					any((context.media, context.container,
						context.fifo, context.socket)):
				attr |= normal
				fg = yellow
			if context.socket:
				fg = magenta
				attr |= normal
			if context.fifo or context.device:
				fg = yellow
				if context.device:
					attr |= normal
			if context.link:
				fg = context.good and cyan or magenta
			if context.tag_marker and not context.selected:
				attr |= normal
				if fg in (red, magenta):
					fg = white
				else:
					fg = red
			if not context.selected and (context.cut or context.copied):
				fg = black
				attr |= bold
			if context.main_column:
				if context.selected:
					attr |= bold
				if context.marked:
					attr |= bold
					fg = red
			if context.badinfo:
				if attr & reverse:
					bg = magenta
				else:
					fg = magenta

		elif context.in_titlebar:
			bg = default
			if context.hostname:
				fg = context.bad and red or blue
				attr |= normal
			elif context.directory:
				fg = white
				attr |= normal
			elif context.tab:
				if context.good:
					bg = black
			elif context.link:
				fg = cyan
				attr |= normal

		elif context.in_statusbar:
			bg = default
			fg = white
			if context.permissions:
				if context.good:
					fg = blue
				elif context.bad:
					fg = magenta
			if context.marked:
				attr |= bold
				fg = red
			if context.message:
				if context.bad:
					attr |= normal
					fg = yellow

		if context.text:
			if context.highlight:
				attr |= reverse

		if context.in_taskview:
			if context.title:
				fg = blue

			if context.selected:
				attr |= reverse

		return fg, bg, attr
