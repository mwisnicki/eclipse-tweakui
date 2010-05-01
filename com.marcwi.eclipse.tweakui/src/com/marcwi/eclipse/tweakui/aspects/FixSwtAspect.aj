package com.marcwi.eclipse.tweakui.aspects;

import org.eclipse.swt.internal.win32.OS;
import org.eclipse.swt.widgets.Tree;

// FIXME fix those access violations from swt.internal.*
//       but I can't get it to depend on swt.win32 if I make myself a fragment of swt

public privileged aspect FixSwtAspect {
	// TODO figure out if it is possible to have classic [+] with modern look

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
