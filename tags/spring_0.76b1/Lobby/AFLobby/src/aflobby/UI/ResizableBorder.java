/*
 * ResizableBorder.java
 * 
 * Created on 08-Aug-2007, 13:27:51
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby.UI;

import java.awt.event.MouseEvent;

/**
 * MySwing: Advanced Swing Utilites
 * Copyright (C) 2005  Santhosh Kumar T
 * <p/>
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * <p/>
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * @author Santhosh Kumar T
 */
public interface ResizableBorder extends javax.swing.border.Border{
    public int getResizeCursor(MouseEvent me);
}