/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package tests {
import flexunit.framework.Assert

import org.flexunit.asserts.assertEquals

public class UnicodeToPostIdEncoderTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [BeforeClass]
    public static function setUpBeforeClass():void {
    }

    [AfterClass]
    public static function tearDownAfterClass():void {
    }

    [Test]
    public function testAppendDelimeter():void {
        Assert.assertEquals("0321o", UnicodeToPostIdEncoder.appendDelimeter("0321"));
    }

    [Test]
    public function testAppendString():void {

    }

    [Test]
    public function testAppendSymbol():void {
        Assert.assertEquals("0321x34", UnicodeToPostIdEncoder.appendSymbol("0321", 0x34))
    }

    [Test]
    public function testDecodeString():void {
        var s:String = "asd`12435ilBJkbvm ���� ������ �������� ����-+)(*&^%$$#@!>><<HKJbhbvsi"
        Assert.assertEquals(s, UnicodeToPostIdEncoder.decodeString(UnicodeToPostIdEncoder.encodeString(s)))
    }

    [Test]
    public function testDecodeArray():void {
        var s1:String = "asd`12435ilBJkbvm ���� ������ �������� ����-+)(*&^%$$#@!>><<HKJbhbvsi"
        var s2:String = "__рлоОПИЛЛМИПгыпп ghgjgj голрлазт8 y9y b38nslvh"
        var s3:String = "x"
        var s4:String = ".yxasdgthr}}}}}}}"
        var arr:Array = UnicodeToPostIdEncoder.decodeStringArray(UnicodeToPostIdEncoder.encodeStringArray([s1,s2,s3,s4]))
        Assert.assertEquals(s1, arr[0]);
        Assert.assertEquals(s2, arr[1]);
        Assert.assertEquals(s3, arr[2]);
        Assert.assertEquals(s4, arr[3]);
    }

    [Test]
    public function testEncodeStringArray():void {
        var arr:Array = ["aaddx23y4","123454622342xaa","0ffdxf4"]
        assertEquals("x61x61x64x64x78x32x33x79x34ox31x32x33x34x35x34x36x32x32x33x34x32x78x61x61ox30x66x66x64x78x66x34", UnicodeToPostIdEncoder.encodeStringArray(arr))
    }

    [Test]
    public function testEncodeSymbol():void {
        Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(0x2), "y2")
        Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(0xa), "ya")
        Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(56), "x38")
        Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(323), "0143")
        Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(0xAFFF), "afff")
        for (var i:int = 0; i < 10000; i++) {
            var num:int = Math.random() * 0xFFFF
            if (num <= 0xF)
                Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(num), "y" + num.toString(16))
            else if (num <= 0xFF)
                Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(num), "x" + num.toString(16))
            else {
                var res:String = num.toString(16)
                if (res.length == 3)
                    Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(num), "0" + res)
                else
                    Assert.assertEquals(UnicodeToPostIdEncoder.encodeSymbol(num), res)
            }
        }

    }
}
}