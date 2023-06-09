#include "mex.h"
#include <iostream>
#include "add.h"
#include "sub.h"
#include "mul.h"
#include "div.h"
#include "SimpleMath.h"
#include "Eigen/Dense"
//�������
void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    mexPrintf("�������������%d\n", nrhs);
    if (nrhs != 3) {        //�ж������������
        mexPrintf("Input numbers must be 3\n");
        return;
    }
    /********************************************************/
    //��ȡ��������ı���
    float a = (double)mxGetScalar(prhs[0]);
    float b = (double)mxGetScalar(prhs[1]);
    float add_result = add(a, b);
    float sub_result = sub(a, b);
    float mul_result = mul(a, b);
    float div_result = div(a, b);
    //�������������ָ��
    plhs[0] = mxCreateDoubleScalar((double)add_result);
    plhs[1] = mxCreateDoubleScalar((double)sub_result);
    plhs[2] = mxCreateDoubleScalar((double)mul_result);
    plhs[3] = mxCreateDoubleScalar((double)div_result);
    /********************************************************/
    SimpleMath simple_math{};
    //��ȡ����ľ���ָ��
    double* input_matrix = mxGetDoubles(prhs[2]);
    //��ȡ����ľ��������������
    size_t row = mxGetM(prhs[2]);
    size_t col = mxGetN(prhs[2]);
    mexPrintf("�����������: %d, �����������: %d\n", row, col);
    simple_math.a = input_matrix[0];
    simple_math.b = input_matrix[1];
    add_result = simple_math.add();
    sub_result = simple_math.sub();
    mul_result = simple_math.mul();
    div_result = simple_math.div();
    //����2x2�����ʵ������
    plhs[4] = mxCreateDoubleMatrix(2, 2, mxREAL);
    //��ȡ�����ָ�벢���и�ֵ
    double* out_matrix = mxGetDoubles(plhs[4]);
    out_matrix[0] = add_result;
    out_matrix[1] = sub_result;
    out_matrix[2] = mul_result;
    out_matrix[3] = div_result;
    /********************************************************/
    Eigen::MatrixXd A(2, 3);
    Eigen::MatrixXd B(3, 2);
    A << 1, 2, 3, 4, 5, 6;
    B << 1, 2, 3, 4, 5, 6;
    Eigen::MatrixXd C = A * B;
    std::cout << "C: \n" << C << std::endl;
    plhs[5] = mxCreateDoubleMatrix(2, 2, mxREAL);
    double* eigen_out = mxGetDoubles(plhs[5]);
    eigen_out[0] = C(0, 0);
    eigen_out[1] = C(1, 0);
    eigen_out[2] = C(0, 1);
    eigen_out[3] = C(1, 1);
    mexPrintf("������������%d\n", nlhs);
}