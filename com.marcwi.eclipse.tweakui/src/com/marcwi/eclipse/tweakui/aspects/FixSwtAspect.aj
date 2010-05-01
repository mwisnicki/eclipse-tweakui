/*-
 * Copyright (c) 2010  Marcin Wisnicki <mwisnicki@gmail.com>.
 * 
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
 * OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */
package com.marcwi.eclipse.tweakui.aspects;

import org.eclipse.swt.internal.win32.OS;
import org.eclipse.swt.widgets.Tree;

// FIXME fix those access violations from swt.internal.*
//       but I can't get it to depend on swt.win32 if I make myself a fragment of swt

public privileged aspect FixSwtAspect {
	// TODO figure out if it is possible to have classic [+] with modern look
	// FIXME tree-tables selection is weird (eg. error log, installed software)

	final static int TVS_SINGLEEXPAND = 0x0400;

	int around() :
		execution(int Tree.widgetStyle()) {
		int style = proceed();
		style |= OS.TVS_HASLINES;
		style &= ~OS.TVS_TRACKSELECT;
		return style;
	}

	boolean around() :
		within(Tree)
		&& call(boolean OS.IsAppThemed()) {
		return false;
	}

	// XXX seems to be unnecessary
	int around(int hWnd, int Msg, int wParam, int lParam) :
		withincode(void Tree.createHandle())
		&& if(false)
		&& args(hWnd, Msg, wParam, lParam)
		&& call(int OS.SendMessage(int, int, int, int))
		&& if (Msg == OS.TVM_SETEXTENDEDSTYLE) {
		lParam &= ~(OS.TVS_EX_FADEINOUTEXPANDOS | OS.TVS_EX_AUTOHSCROLL);
		return proceed(hWnd, Msg, wParam, lParam);
	}
}
