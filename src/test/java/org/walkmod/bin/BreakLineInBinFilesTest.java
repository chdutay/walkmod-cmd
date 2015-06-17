package org.walkmod.bin;

import java.io.File;
import java.io.FileReader;

import junit.framework.Assert;

import org.junit.Test;

public class BreakLineInBinFilesTest {
	@Test
	public void testDOSCharacters() throws Exception {
		
		Assert.assertEquals(false, checkFile(new File("src/main/bin/walkmod")));
		Assert.assertEquals(false, checkFile(new File("src/main/bin/walkmodDebug")));
	}

	private boolean checkFile(File file) throws Exception {
		FileReader fr = new FileReader(file);
		boolean DOSCharFound = false;
		char[] chars = new char[1024];
		try {

			int size = fr.read(chars);
			while (size != -1 && !DOSCharFound) {
				for (int i = 0; i < chars.length && !DOSCharFound; i++) {
					DOSCharFound = chars[i] == '\r';
				}
				size = fr.read(chars);
			}

		} finally {
			fr.close();
		}

		return DOSCharFound;
	}
}
