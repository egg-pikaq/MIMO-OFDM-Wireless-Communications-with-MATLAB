# 项目学习路线报告

> 项目：MIMO-OFDM-Wireless-Communications-with-MATLAB  
> 目的：以教材《MIMO-OFDM无线通信技术及MATLAB实现》（Yong Soo Cho 等著）为主线，规划阅读本仓库代码的顺序。  
> 盘点依据：仓库当前 README、目录与 MATLAB 源码文件名/函数头。代码仓库注明仍在整理中，部分中文注释存在编码显示问题；下面按代码功能归类，章节对应是学习建议，不保证每个文件都与教材同名章节一一对应。

## 1. 项目概况

仓库是教材配套 MATLAB 示例的平铺式集合：141 个 `.m` 文件放在根目录，另有 115 个 WiBro 前导码/标准数据文件、一个备份压缩包、3 个 OFDM BER 数据文件、README、许可文件和一个程序索引 PDF。文件夹不是按章节组织的，入口脚本通常直接调用根目录里的函数；运行时应把项目根目录加入 MATLAB 当前路径。

README 表示仓库添加过部分中文注释和中文版教材公式页码，也明确代码注释尚未补全、项目仍在整理中。请把页码注释当作定位线索，而不要假设所有程序都标注了页码。

## 2. 文件夹与非代码文件

| 路径 | 内容 | 学习时的用途 |
|---|---|---|
| `Wibro-Preamble/` | 115 个 `.dat` 文件，包括 `Preamble_sym0.dat` 到 `Preamble_sym113.dat`，以及 `C80216e-04_241r1_pdf.dat` | WiBro/IEEE 802.16e 前导码及相关标准数据。被同步、前导码、PAPR 等示例读取时再研究，不必逐个手工打开。 |
| `zip-file/` | `MIMO-OFDM-Wireless-Communications-with-MATLAB-backup201703031327.7z` | 项目历史备份。除非需要查找当前目录缺失的原始文件，否则作为归档即可。 |
| 根目录 `OFDM_BER_*.dat` | 3 份 BER 曲线数据：AWGN、信道条件下，不同 CP/GI 配置 | 可能用于对照或绘图；先查看具体脚本是否读取这些文件。 |
| 根目录 `MIMO_OFDM_program_list.pdf` | 配套程序索引 PDF | 可作为教材程序与文件名的交叉索引。 |
| 根目录 `README.md`、`LICENSE`、`license.txt` | 项目说明和许可 | 开始前阅读 README；复用代码前确认许可要求。 |

## 3. 建议的整体学习顺序

推荐围绕一个核心链路推进：**比特/符号 → OFDM 调制 → 传播信道 → 同步/估计 → 检测解调 → BER**。每一阶段先看短函数，再运行对应仿真脚本，最后改一个参数并观察图形或 BER 的变化。

### 阶段 0：准备 MATLAB 与代码阅读方法

先读 `README.md` 和许可文件。辨认文件类型：以 `function` 开头的是可复用函数；以参数设置、`clear`、循环和绘图为主的通常是示例/仿真脚本。运行脚本前检查它是否会清空工作区、是否依赖外部数据，以及是否需要 Communications Toolbox 等工具箱。先不要一次运行所有文件。

建议从 `test_orthogonality.m` 起步，复习复指数、DFT/FFT 与子载波正交性。然后看 `OFDM_basic.m`、`OFDM_signal.m`，把参数、频域符号、IFFT 输出和频谱/时域波形对应起来。

### 阶段 1：调制、OFDM 帧结构和保护间隔

先看符号映射：`mapper.m`、`modulation.m`、`modulator.m`、`QPSK_mapper.m`、`QAM16_mod.m`、`QAM16_demapper.m`、`QAM16_slicer.m`。用 `ber_QAM.m` 对照理论 BER。

再看 OFDM 结构：`OFDM_basic.m`、`OFDM_signal.m`、`IFFT_oversampling.m`、`add_CP.m`、`remove_CP.m`、`guard_interval.m`、`remove_GI.m`、`add_pilot.m`、`zero_padding.m`、`zero_insertion.m`。重点理解 FFT 点数、有效子载波、循环前缀、导频位置及行列/向量尺寸。

建议先画出单个 OFDM 符号从映射、IFFT、加 CP 到去 CP、FFT、判决的变量流，再阅读涉及多帧与多天线的脚本。

### 阶段 2：基线链路与误码率

以 `OFDM_basic.m` 建立最简链路，再阅读 `OFDM_signal.m` 和 `plot_ber.m`。仓库还提供 `OFDM_BER_AWGN_CP_GL16.dat`、`OFDM_BER_CH_CP_GL16.dat`、`OFDM_BER_CH_CP_GL3.dat`，可以用来理解 AWGN/多径信道和保护间隔对 BER 的影响；应通过 `rg` 搜索文件名确认具体读入程序。

练习：只改变调制阶数、CP 长度或 SNR，记录 BER 曲线变化。确认仿真误码数与理论曲线趋势后再进入 MIMO。

### 阶段 3：无线信道与传播模型

按由简单到复杂阅读：

1. 平坦衰落与统计模型：`Ray_model.m`、`Ric_model.m`、`ray_fading.m`、`Jakes_Flat.m`、`FWGN.m`、`FWGN_model.m`、`FWGN_ff.m`、`FWGN_tf.m`、`gen_filter.m`、`Doppler_spectrum.m`、`Doppler_PSD_function.m`。
2. 多径功率时延分布和标准信道：`exp_pdp.m`、`IEEE802_11_model.m`、`SUI_parameters.m`、`SUI_fading.m`、`channel1.m`、`channel_coeff.m`。
3. 路径损耗：`PL_free.m`、`PL_logdist_or_norm.m`、`PL_Hata.m`、`PL_IEEE80216d.m`，以及对应的 `plot_PL_*.m`。
4. UWB/S-V 连续时间信道：`SV_model_ct.m`、`UWB_model_ct.m`、`UWB_parameters.m`、`convert_UWB_ct.m`、`UWB_convert_ct.m`，以及 `plot_SV_model_ct.m`、`plot_UWB_channel.m`。
5. 可视化示例：`plot_ray_fading.m`、`plot_Ray_Ric_channel.m`、`plot_Jakes_model.m`、`plot_FWGN.m`、`plot_SUI_channel.m`、`plot_IEEE80211_model.m`、`plot_2ray_exp_model.m`。

先弄清每个模型输出代表“复增益、冲激响应、功率时延分布还是路径损耗”，以及时间/频率单位，再把信道接入 OFDM 基线链路。

### 阶段 4：同步、信道估计和均衡

同步分两类：载波频偏 CFO：`add_CFO.m`、`CFO_CP.m`、`CFO_Moose.m`、`CFO_Classen.m`、`CFO_estimation.m`；定时偏差 STO：`add_STO.m`、`STO_by_correlation.m`、`STO_by_difference.m`、`STO_estimation.m`、`do_STO_CFO1.m`。先读注入偏差的函数，再读估计器，最后看比较/仿真入口。

信道估计与均衡建议顺序：`add_pilot.m` → `LS_CE.m` → `MMSE_CE.m` → `interpolate.m` → `channel_estimation.m`。重点看导频提取、插值维度、估计误差随 SNR/导频间隔的变化。

### 阶段 5：MIMO 检测、分集与空时编码

先看单用户 MIMO 检测：`MMSE_detection_2x2.m`、`pre_MMSE.m`、`OSIC_detector.m`、`SD_detector.m`、`SQRD_.m`、`LRAD_MMSE.m`、`QRM_MLD_detector.m`、`QRM_MLD_soft.m`、`QRM_MLD_simulation.m`。辅助函数包括 `sort_matrix.m`、`calculate_norm.m`、`bound.m`、`stage_processing.m`、`stage_processing1.m`、`radius_control.m`、`compare_vector_norm.m`、`vector_comparison.m`、`list_length.m`、`original_LLL_.m`。阅读时先抓住基准 ZF/MMSE，再比较 OSIC、球形译码、格约简和近似/软输出算法的复杂度与误码性能。

接着学分集和编码：`Alamouti_scheme.m`、`Alamouti_2x1_precoding.m`、`Alamouti_2x1_ant_selection.m`、`STBC_3x4_simulation.m`；再看空时格码：`trellis_encoder.m`、`STTC_stage_modulation.m`、`STTC_modulator.m`、`STTC_detector.m`、`STTC_simulation.m`。配套还包括 `data_generator.m`、`Viterbi_init.m`、`soft_hard_SISO.m`、`soft_decision_sigma.m`、`soft_output2x2.m`。

最后再读多用户/预编码：`Block_diagonalization.m`、`multi_user_MIMO.m`、`Dirty_or_TH_precoding.m`、`codebook_generator.m`、`MRC_scheme.m`、`MIMO_channel_cap_ant_sel_optimal.m`、`MIMO_channel_cap_ant_sel_subopt.m`、`Ergodic_Capacity_*.m`、`Water_Pouring.m`。

### 阶段 6：OFDM 波形质量与 PAPR

最后研究 `PAPR.m`、`single_carrier_PAPR.m`、`PAPR_of_preamble.m`、`PARR_of_preamble.m`、`PAPR_of_Chu.m`、`clipping.m`、`SQNR_with_quantization_clipping.m`、`PDF_of_clipped_and_filtered_OFDM_signal.m`、`CCDF_of_clipped_filtered_OFDM_signal.m`、`CCDF_PTS.m`、`compare_CCDF_PTS.m`、`CCDF_PAPR_DFTspreading.m`、`compare_DFT_spreading.m`、`compare_DFT_spreading_w_psf.m`、`CCDF_OFDMA.m`、`OL_CL_Comparison.m`、`plot_CCDF.m`。

这一组适合在理解 OFDM 调制后学习：关注 PAPR/CCDF 定义、过采样、削峰失真、PTS 和 DFT spreading 的性能/复杂度权衡。前导码类示例可能会用到 `Wibro-Preamble/` 数据。

## 4. 根目录 MATLAB 文件的功能索引

下表把平铺的源码按用途重新分组。同一文件可能同时承担示例入口和算法说明作用。

| 功能组 | 文件 |
|---|---|
| OFDM 基础、帧结构与映射 | `OFDM_basic.m`, `OFDM_signal.m`, `test_orthogonality.m`, `mapper.m`, `modulation.m`, `modulator.m`, `QPSK_mapper.m`, `QAM16_mod.m`, `QAM16_demapper.m`, `QAM16_slicer.m`, `QAM16_slicer_soft.m`, `add_CP.m`, `remove_CP.m`, `guard_interval.m`, `remove_GI.m`, `add_pilot.m`, `IFFT_oversampling.m`, `zero_padding.m`, `zero_insertion.m`, `assign_offset.m`, `dB2w.m`, `Q.m` |
| 信道与传播 | `channel1.m`, `channel_coeff.m`, `Ray_model.m`, `Ric_model.m`, `ray_fading.m`, `Jakes_Flat.m`, `FWGN.m`, `FWGN_model.m`, `FWGN_ff.m`, `FWGN_tf.m`, `gen_filter.m`, `gen_phase.m`, `Doppler_PSD_function.m`, `Doppler_spectrum.m`, `exp_pdp.m`, `IEEE802_11_model.m`, `SUI_parameters.m`, `SUI_fading.m`, `equalpower_subray.m`, `PL_free.m`, `PL_logdist_or_norm.m`, `PL_Hata.m`, `PL_IEEE80216d.m`, `SV_model_ct.m`, `UWB_model_ct.m`, `UWB_parameters.m`, `convert_UWB_ct.m`, `UWB_convert_ct.m` |
| 信道/模型绘图 | `plot_2ray_exp_model.m`, `plot_ray_fading.m`, `plot_Ray_Ric_channel.m`, `plot_Jakes_model.m`, `plot_FWGN.m`, `plot_modified_FWGN.m`, `plot_SUI_channel.m`, `plot_IEEE80211_model.m`, `plot_PL_general.m`, `plot_PL_Hata.m`, `plot_PL_IEEE80216d.m`, `plot_SV_model_ct.m`, `plot_UWB_channel.m` |
| 同步与信道估计 | `add_CFO.m`, `CFO_CP.m`, `CFO_Moose.m`, `CFO_Classen.m`, `CFO_estimation.m`, `add_STO.m`, `STO_by_correlation.m`, `STO_by_difference.m`, `STO_estimation.m`, `do_STO_CFO1.m`, `LS_CE.m`, `MMSE_CE.m`, `interpolate.m`, `channel_estimation.m` |
| MIMO 检测、容量与预编码 | `MMSE_detection_2x2.m`, `pre_MMSE.m`, `OSIC_detector.m`, `SD_detector.m`, `SQRD_.m`, `LRAD_MMSE.m`, `original_LLL_.m`, `QRM_MLD_detector.m`, `QRM_MLD_soft.m`, `QRM_MLD_simulation.m`, `sort_matrix.m`, `calculate_norm.m`, `bound.m`, `radius_control.m`, `stage_processing.m`, `stage_processing1.m`, `compare_vector_norm.m`, `vector_comparison.m`, `list_length.m`, `Block_diagonalization.m`, `multi_user_MIMO.m`, `Dirty_or_TH_precoding.m`, `codebook_generator.m`, `MRC_scheme.m`, `MIMO_channel_cap_ant_sel_optimal.m`, `MIMO_channel_cap_ant_sel_subopt.m`, `Ergodic_Capacity_CDF.m`, `Ergodic_Capacity_Correlation.m`, `Ergodic_Capacity_vs_SNR.m`, `Water_Pouring.m` |
| 空时编码、分集与编码 | `Alamouti_scheme.m`, `Alamouti_2x1_precoding.m`, `Alamouti_2x1_ant_selection.m`, `STBC_3x4_simulation.m`, `trellis_encoder.m`, `STTC_stage_modulation.m`, `STTC_modulator.m`, `STTC_detector.m`, `STTC_simulation.m`, `data_generator.m`, `Viterbi_init.m`, `soft_hard_SISO.m`, `soft_decision_sigma.m`, `soft_output2x2.m`, `MRC_scheme.m` |
| PAPR、削峰与 DFT spreading | `PAPR.m`, `single_carrier_PAPR.m`, `PAPR_of_preamble.m`, `PARR_of_preamble.m`, `PAPR_of_Chu.m`, `clipping.m`, `SQNR_with_quantization_clipping.m`, `PDF_of_clipped_and_filtered_OFDM_signal.m`, `CCDF_of_clipped_filtered_OFDM_signal.m`, `CCDF_PTS.m`, `compare_CCDF_PTS.m`, `CCDF_PAPR_DFTspreading.m`, `compare_DFT_spreading.m`, `compare_DFT_spreading_w_psf.m`, `CCDF_OFDMA.m`, `OL_CL_Comparison.m`, `plot_CCDF.m` |
| 理论 BER 与其他辅助 | `ber_QAM.m`, `plot_ber.m`, `calculate_norm.m`, `modulo.m`, `bound.m` |

## 5. 一条可执行的首轮阅读清单

如果希望先用最短路径建立全貌，可以依次打开：

1. `README.md`、`MIMO_OFDM_program_list.pdf`。
2. `test_orthogonality.m`、`OFDM_basic.m`、`OFDM_signal.m`。
3. `mapper.m`、`add_CP.m`、`remove_CP.m`、`guard_interval.m`。
4. `Ray_model.m`、`channel1.m`、`PL_free.m`，理解信道抽象层次。
5. `CFO_estimation.m`、`STO_estimation.m`、`channel_estimation.m`。
6. `MMSE_detection_2x2.m`、`Alamouti_scheme.m`、`QRM_MLD_simulation.m`。
7. `PAPR.m`、`CCDF_PTS.m`、`compare_DFT_spreading.m`。

每次运行前建议先查看脚本开头的参数和末尾绘图/保存语句，并从调用它的脚本反向追函数。遇到乱码时，先确认源文件编码；勿对整个项目批量转码，以免破坏仍为 GBK/ANSI 的注释或数据。

## 6. 阅读时建议记录的变量

为每个例子记下：发射天线数 `NT`、接收天线数 `NR`、FFT 点数 `Nfft`、CP/GI 长度、调制阶数、SNR/EbN0 定义、信道模型、导频位置、迭代帧/包数、输出 BER/容量/PAPR 指标。特别留意 `Nfft`、子载波索引及数据矩阵的行列方向，因为不同脚本可能沿用不同维度约定。

> 教材建议按理论章节阅读，本报告按代码依赖和概念递进排序。若程序索引 PDF 提供了明确的教材章节/图号映射，应以该索引和教材正文为准，并将本表作为代码功能导航。
