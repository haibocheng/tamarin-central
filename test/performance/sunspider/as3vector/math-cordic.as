/*
 Copyright (C) 2007 Apple Inc.  All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY APPLE COMPUTER, INC. ``AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE COMPUTER, INC. OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

/*
 * Copyright (C) Rich Moore.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE COMPUTER, INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

/////. Start CORDIC

var AG_CONST:Number = 0.6072529350;

function FIXED(X:Number):Number
{
  return X * 65536.0;
}

function FLOAT(X:Number):Number
{
  return X / 65536.0;
}

function DEG2RAD(X:Number):Number
{
  return 0.017453 * (X);
}

var Angles:Vector.<Number> = new Vector.<Number>();
Angles.push(FIXED(45.0));
Angles.push(FIXED(26.565));
Angles.push(FIXED(14.0362));
Angles.push(FIXED(7.12502));
Angles.push(FIXED(3.57633));
Angles.push(FIXED(1.78991));
Angles.push(FIXED(0.895174));
Angles.push(FIXED(0.447614));
Angles.push(FIXED(0.223811));
Angles.push(FIXED(0.111906));
Angles.push(FIXED(0.055953));
Angles.push(FIXED(0.027977));

function cordicsincos():void {
    var X:Number;
    var Y:Number;
    var TargetAngle:Number;
    var CurrAngle:Number;
    var Step:int;
 
    X = FIXED(AG_CONST);         /* AG_CONST * cos(0) */
    Y = 0;                       /* AG_CONST * sin(0) */

    TargetAngle = FIXED(28.027);
    CurrAngle = 0;
    for (Step = 0; Step < 12; Step++) {
        var NewX:Number;
        if (TargetAngle > CurrAngle) {
            NewX = X - (Y >> Step);
            Y = (X >> Step) + Y;
            X = NewX;
            CurrAngle += Angles[Step];
        } else {
            NewX = X + (Y >> Step);
            Y = -(X >> Step) + Y;
            X = NewX;
            CurrAngle -= Angles[Step];
        }
    }
}

///// End CORDIC

function cordic( runs:int ):int {
  var start:int = getTimer();

  for ( var i:int = 0 ; i < runs ; i++ ) {
      cordicsincos();
  }

  var end:int = getTimer();

  return end - start;
}
function runMathCordic():int {
var _sunSpiderStartDate:int = getTimer();
cordic(25000);
var _sunSpiderInterval:int = getTimer() - _sunSpiderStartDate;
return _sunSpiderInterval;
}

print("metric math-cordic-as3vector " + runMathCordic());
