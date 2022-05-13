import React from 'react';

/// import axios 
import axios from '../../../utils/server';

/// import react router dom
import { Link } from "react-router-dom";

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// combobox react for load data mesin
import AsyncSelect from 'react-select/async'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';
import swal from 'sweetalert';

class ListKomponen extends React.Component {
    /// null or empty handler
    nullcondition(params) {
        if (params.data.ketkomponen === '') {
            return '-'
        } else {
            return params.data.ketkomponen
        }
    }
    constructor(props) {
        super(props)
        this.state = {
            /// state load data mesin for dropdown 
            dataMesin: '',
            idmesin:'',
            /// flag for handlind data grid if false data grid hide 
            loadingKomponen: false,
            /// setate load data komponen
            dataKomponen: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "Nama Komponen",
                    field: 'nama',
                },
                {
                    headerName: "Keterangan",
                    field: 'ketkomponen',
                    valueGetter: this.nullcondition
                },
                {
                    headerName: "Kategori",
                    field: 'kategori'
                },
                {
                    headerName: 'Action',
                    field: 'idmesin',
                    cellRendererFramework: (params) => <div className='inline-flex rounded-md' role='group'><Link to='/editkomponen/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link><button onClick={()=>this.KonfirmHapusData(params)} className="py-2 px-2 text-sm font-small rounded-r-lg border border-gray-300 bg-red-500 text-white">Delete</button></div>
                }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: false,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }

    async KonfirmHapusData(params){
        swal({
            title: `Yakin Akan Menghapus Data ${params.data.nama}?`,
            text: "Pastikan data yang anda hapus sudah sesuai!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
            closeOnClickOutside: false,
            closeOnEsc: false,
        })
            .then((willDelete) => {
                if (willDelete) {
                    this.HapusData(params.data.idkomponen)
                    // swal("Poof! Your imaginary file has been deleted!", {
                    //     icon: "success",
                    // });
                }
            });
    }

    /// action delete
    async HapusData(idkomponen){
        await axios.delete("komponen/" + idkomponen, {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            swal(`${response.data.message}`, {
                icon: "success",
            });
            this.loadDataKomponen(this.state.idmesin)
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }


    /// getting data komponen from api with parameter idmesin
    async loadDataKomponen(idmesin) {
        await axios.get("komponen/" + idmesin, {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ dataKomponen: response.data.data })
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    /// getting data mesin from api for dropdown mesin
    loadMesin = () => {
        return axios.get("mesin/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ loadingKomponen: true })
            const respon = response.data.data
            return respon
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    render() {
        return (
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                <div className="md:container md:mx-auto mt-3">
                    <div className='grid grid-cols-6 gap-4 '>
                        <div className='col-start-1 col-end-3'>
                            {/* /// name page */}
                            <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                                Data Komponen
                            </h1>
                        </div>
                        {/* /// button tambah */}
                        <div className='col-end-7 col-span-1'>
                            <div className="flex-auto justify-center items-center mt-6">
                                <Link to='/addkomponen'>
                                    <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-700">Tambah Komponen</button>
                                </Link>
                            </div>
                        </div>
                    </div>
                    <div className='grid grid-cols-6 gap-4 items-center bg-blue-200'>
                        {/* /// label combo box */}
                        <div className='ml-5 text-lg'>
                            <label>Pilih Mesin : </label>
                        </div>
                        {/* /// combo box mesin */}
                        <div className='col-span-5'>
                            <AsyncSelect
                                cacheOptions
                                defaultOptions
                                getOptionLabel={e => e.nomesin + " - " + e.keterangan}
                                getOptionValue={e => e.idmesin}
                                loadOptions={this.loadMesin}
                                placeholder="Pilih Mesin..."
                                gridOptions={this.state.gridOptions}
                                onChange={(value) => { 
                                    this.loadDataKomponen(value.idmesin)
                                    this.setState({idmesin: value.idmesin})
                                }}
                            />
                        </div>
                    </div>
                    {/* /// condition to load data grid komponent */}
                    {this.state.loadingKomponen && (
                        <div className='ag-theme-alpine mt-4' style={{ height: '100vh' }}>
                            <AgGridReact
                                suppressExcelExport={true}
                                rowData={this.state.dataKomponen}
                                columnDefs={this.state.columnDefs}
                                // onGridReady={onGridReady}
                                animateRows={true}
                                defaultColDef={this.state.defaultColDef}
                                loadingCellRendererParams={this.state.loadingCellRendererParams}
                            />
                        </div>
                    )}
                </div>
            </>
        );
    }
}

export default ListKomponen;
