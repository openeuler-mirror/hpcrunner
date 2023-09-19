package com.example.demo_test.demo;

import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.MethodVisitor
import org.objectweb.asm.Opcodes;

import java.util.ArrayList;
import java.util.List;

public class MetaspaceTest extends ClaseeLoader{
	public void test(){
		// �����
		List<Class<?>> classes = new ArrayList<~>();
		// ѭ��1000w������1000w����ͬ����
		for(int i = 0; i < 100000;++i){
			
			ClassWriter cw = new ClassWriter(0);
			
			// ����һ������ΪClass{i},���ķ�����Ϊpublic,����Ϊjava/lang/Object����ʵ���κνӿ�
			cw.visit(OpCodes.V1_1, OpCodes.ACC_PUBLIC, "Class" + i, null, "java/lang/Object", null);
			// ���幹�캯��
			
			MethodVisitor mw = cw.visitMethod(OpCodes.ACC_PUBLIC, "<init>", "{}V", null ,null);
			
			// ��һ��ָ��Ϊ����this
			mw.visitVarInsn(OpCodes.ALOAD, 0);
			
			// �ڶ���ָ��Ϊ���ø����Object�Ĺ��캯��
			mw.visitMethodInsn(OpCodes.INVOKESPECIAL, "java/lang/Object", "<init>", "()V", false);
			
			// ������ָ��ΪRETURN
			mw.visitInsn(OpCodes.RETURN);
			mw.visitMaxs(1, 1);
			mw.visitEnd();
			
			MetaspaceTest test  = new MetaspaceTest();
			byte[] code = cw.toByteArray();
			// ������
			Class<?> exampleClass = test.defineClass("Claass" + i, code, 0, code.length);
			classes.add(exampleClass)
		}
	}
}