package com.marcwi.eclipse.tweakui.aspects;

import org.eclipse.swt.internal.win32.OS;
import org.eclipse.swt.widgets.Tree;

public privileged aspect FixSwtAspect {

	final static int TVS_SINGLEEXPAND = 0x0400;

	int around() :
		execution(int Tree.widgetStyle()) {
		int style = proceed();
		style |= OS.TVS_HASLINES;
		style &= ~OS.TVS_TRACKSELECT;
		return style;
	}

	boolean around() :
		withincode(* Tree.*(..))
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
