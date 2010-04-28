package com.marcwi.eclipse.tweakui.aspects;

import org.eclipse.swt.internal.win32.OS;
import org.eclipse.swt.widgets.Tree;

public privileged aspect FixSwtAspect {

	// FIXME Mylyn Task List is broken
	// FIXME PackageExplorer and Outline selection broken
	
	final static int TVS_SINGLEEXPAND = 0x0400;

	int around() :
		execution(int Tree.widgetStyle()) {
		int style = proceed();
		style |= OS.TVS_HASLINES;
		style &= ~(TVS_SINGLEEXPAND | OS.TVS_TRACKSELECT);
		return style;
	}

	int around() :
		withincode(void Tree.createHandle())
		&& call(int OS.SetWindowTheme(..)) {
		return 0;
	}

	// XXX seems to be unnecessary
	int around(int hWnd, int Msg, int wParam, int lParam) :
		withincode(void Tree.createHandle())
		&& args(hWnd, Msg, wParam, lParam)
		&& call(int OS.SendMessage(int, int, int, int))
		&& if (Msg == OS.TVM_SETEXTENDEDSTYLE) {
		lParam &= ~(OS.TVS_EX_FADEINOUTEXPANDOS | OS.TVS_EX_AUTOHSCROLL);
		return proceed(hWnd, Msg, wParam, lParam);
	}
}
